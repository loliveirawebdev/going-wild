import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:going_wild/content/board.dart';
import 'package:going_wild/content/character/enemies/enemies.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/engines/character/basic_character_engine.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/ambush/ambush_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/knockback/knockback_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/pull/pull_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/enemies_around_focus_target.dart';
import 'package:going_wild/ui/core/design/painted_scene.dart';
import 'package:going_wild/ui/game/unit_stage/performance/ability_cast.dart';
import 'package:going_wild/ui/game/unit_stage/sprite_ticks.dart';
import 'package:going_wild/ui/game/unit_stage/unit/unit_activity.dart';
import 'package:going_wild/ui/game/unit_stage/unit/unit_direction.dart';
import 'package:going_wild/ui/game/unit_stage/unit/unit_pose.dart';
import 'package:going_wild/ui/game/unit_stage/unit/unit_sprite.dart';
import 'package:going_wild/ui/game/unit_stage/unit_stage_game.dart';
import 'package:going_wild/ui/game/widgets/board_scene/board_scene_layout.dart';

const previewRegion = Rect.fromLTWH(60, 330, 820, 760);

const _attackPause = 6;
const _abilityPause = 10;
const _deathPause = 15;
const _aimReach = 120.0;
const _aimLift = 30.0;

const _ownSide = (caster: Position(row: 4, column: 1), allies: [Position(row: 4, column: 2), Position(row: 5, column: 1)]);
const _otherSide = [Position(row: 2, column: 1), Position(row: 2, column: 2), Position(row: 1, column: 2), Position(row: 2, column: 0)];
const _enemyCaster = (caster: Position(row: 2, column: 1), allies: [Position(row: 2, column: 2), Position(row: 1, column: 2)]);
const _teamFoes = [Position(row: 4, column: 1), Position(row: 4, column: 2), Position(row: 5, column: 1), Position(row: 4, column: 0)];

enum PreviewAnimation {
  idle('Parado'),
  walk('Andar'),
  attack('Ataque'),
  ability('Habilidade'),
  death('Morte');

  final String label;
  const PreviewAnimation(this.label);
}

class SpritePreviewGame extends UnitStageGame {
  SpritePreviewGame({required this.character}) : super(boardRegion: previewRegion);

  final Character character;

  late UnitSprite _caster;
  final _allies = <UnitSprite>[];
  final _foes = <UnitSprite>[];
  TimerComponent? _loop;
  var _isPerforming = false;
  final _homes = <UnitSprite, ({Position position, UnitDirection facing})>{};

  late var _direction = restingDirection;

  UnitDirection get restingDirection => _isTeamCharacter ? UnitDirection.backRight : UnitDirection.frontRight;
  bool get _isTeamCharacter => allTeamCharacters.contains(character);
  Position get _casterPosition => _isTeamCharacter ? _ownSide.caster : _enemyCaster.caster;

  @override
  Future<void> onLoad() async {
    final board = await _decodedImage(PaintedScene.board.assetPath);
    stage.add(_BoardBackdrop(board));

    _caster = _addUnit(character, at: _casterPosition, facing: _direction);

    final allyPositions = _isTeamCharacter ? _ownSide.allies : _enemyCaster.allies;
    final foePositions = _isTeamCharacter ? _otherSide : _teamFoes;
    final allyCharacters = (_isTeamCharacter ? allTeamCharacters : allEnemyCharacters).where((other) => other != character);
    final foeCharacters = _isTeamCharacter ? allEnemyCharacters : allTeamCharacters;
    final allyFacing = _isTeamCharacter ? UnitDirection.backRight : UnitDirection.frontRight;
    final foeFacing = _isTeamCharacter ? UnitDirection.frontRight : UnitDirection.backRight;

    for (final (position, ally) in _zip(allyPositions, allyCharacters)) {
      _allies.add(_addUnit(ally, at: position, facing: allyFacing));
    }
    for (final (position, foe) in _zip(foePositions, foeCharacters)) {
      _foes.add(_addUnit(foe, at: position, facing: foeFacing));
    }
  }

  void face(UnitDirection direction) {
    _direction = direction;
    if (isLoaded) _caster.facing = direction;
  }

  void play(PreviewAnimation animation) {
    if (!isLoaded) return;

    _loop?.removeFromParent();
    _loop = null;
    _ensureCasterIsStanding();
    _caster.facing = _direction;

    switch (animation) {
      case PreviewAnimation.idle:
        _caster.rest();
      case PreviewAnimation.walk:
        _caster.walkInPlace();
      case PreviewAnimation.attack:
        _repeatEvery(attackTicks + _attackPause, _attackAlongDirection);
      case PreviewAnimation.ability:
        _repeatEvery(abilityTicks + _abilityPause, _caster.castAbility);
      case PreviewAnimation.death:
        _repeatEvery(deathTicks + _deathPause, _dieAgain);
    }
  }

  void changeSpeed(double timeScale) => stage.timeScale = timeScale;

  void triggerAbility() {
    if (!isLoaded || _isPerforming) return;

    play(PreviewAnimation.idle);
    final target = _foes.first;
    final struckEnemies = [
      for (final foe in _foes)
        if (foe == target || _homeOf(foe).distanceToPosition(_homeOf(target)) == 1) foe,
    ];

    final performance = stage.perform(
      AbilityCast(
        caster: _caster,
        target: target,
        allies: _allies,
        enemies: _foes,
        struckEnemies: struckEnemies,
        relocations: _relocationsFor(target: target, struckEnemies: struckEnemies),
      ),
    );

    if (performance == null) return;
    _isPerforming = true;
    performance.removed.then((_) => _returnEveryoneHome());
  }

  Map<UnitSprite, Offset> _relocationsFor({required UnitSprite target, required List<UnitSprite> struckEnemies}) {
    final casterHome = _homeOf(_caster);
    final occupied = {
      for (final unit in [_caster, ..._allies, ..._foes]) _homeOf(unit),
    };
    final landings = <UnitSprite, Position>{};

    void move(UnitSprite unit, Position landing) {
      occupied
        ..remove(_homeOf(unit))
        ..add(landing);
      landings[unit] = landing;
    }

    Position? freeNeighborOf(Position anchor) =>
        board.neighborPositionsAround(anchor).where((position) => !occupied.contains(position)).firstOrNull;

    for (final effect in character.ability.effects) {
      switch (effect) {
        case KnockbackEffect(:final cells, target: final pushedTarget):
          for (final unit in pushedTarget is EnemiesAroundFocusTarget ? struckEnemies : [target]) {
            final landing = _knockbackLandingOf(_homeOf(unit), awayFrom: casterHome, cells: cells, occupied: occupied);
            if (landing != _homeOf(unit)) move(unit, landing);
          }
        case PullEffect():
          if (freeNeighborOf(casterHome) case final landing?) move(target, landing);
        case AmbushEffect():
          if (freeNeighborOf(_homeOf(target)) case final landing?) move(_caster, landing);
        case _:
          break;
      }
    }

    return {for (final MapEntry(key: unit, value: landing) in landings.entries) unit: _cellCenterOf(landing)};
  }

  static Position _knockbackLandingOf(Position start, {required Position awayFrom, required int cells, required Set<Position> occupied}) {
    var landing = start;
    for (var step = 1; step <= cells; step++) {
      final next = start.positionAwayFrom(awayFrom, steps: step);
      if (!board.isPositionWithinBounds(next) || occupied.contains(next)) break;
      landing = next;
    }

    return landing;
  }

  void _returnEveryoneHome() {
    _isPerforming = false;
    for (final MapEntry(key: unit, value: home) in _homes.entries) {
      if (!unit.isMounted) continue;
      final center = _cellCenterOf(home.position);
      unit
        ..teleportTo(Vector2(center.dx, center.dy))
        ..facing = unit == _caster ? _direction : home.facing;
    }
  }

  void _attackAlongDirection() {
    _caster.facing = _direction;
    final toward = _caster.stagePoint + _direction.advance * _aimReach;
    stage.attack(_caster, toward: toward, aim: toward - const Offset(0, _aimLift));
  }

  void _dieAgain() {
    _ensureCasterIsStanding();
    _caster.die();
  }

  void _ensureCasterIsStanding() {
    if (!_caster.isDying && _caster.isMounted) return;

    _caster.removeFromParent();
    _homes.remove(_caster);
    _caster = _addUnit(character, at: _casterPosition, facing: _direction);
  }

  void _repeatEvery(int ticks, void Function() action) {
    action();
    _loop = TimerComponent(period: ticks / spriteTicksPerSecond, repeat: true, onTick: action);
    stage.add(_loop!);
  }

  UnitSprite _addUnit(Character character, {required Position at, required UnitDirection facing}) {
    final unit = stage.addUnit(
      at: _cellCenterOf(at),
      facing: facing,
      character: character,
      isRanged: basicCharacterEngine.statsAtStars(character, stars: 1).isRanged,
    );

    _homes[unit] = (position: at, facing: facing);
    return unit;
  }

  Position _homeOf(UnitSprite unit) => _homes[unit]!.position;

  static Offset _cellCenterOf(Position position) => BoardSceneLayout.cellRectOf(board, position, scale: 1).center;

  static Iterable<(Position, Character)> _zip(List<Position> positions, Iterable<Character> characters) => [
    for (final (index, character) in characters.take(positions.length).indexed) (positions[index], character),
  ];

  static Future<Image> _decodedImage(String assetPath) async {
    final bytes = await rootBundle.load(assetPath);
    final codec = await instantiateImageCodec(bytes.buffer.asUint8List());
    return (await codec.getNextFrame()).image;
  }
}

class _BoardBackdrop extends Component {
  _BoardBackdrop(this.image) : super(priority: -1);

  final Image image;
  final _paint = Paint()..filterQuality = FilterQuality.medium;

  @override
  void render(Canvas canvas) => canvas.drawImage(image, Offset.zero, _paint);
}
