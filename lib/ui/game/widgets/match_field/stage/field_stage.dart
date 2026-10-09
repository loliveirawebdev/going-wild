import 'dart:collection';
import 'dart:math';

import 'package:flame/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:going_wild/domain/models/board/board.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/combat/combat_rules.dart';
import 'package:going_wild/domain/models/combat_history/causes/combat_history_cause.dart';
import 'package:going_wild/domain/models/combat_history/entries/combat_history_entry.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay_combatant.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay_frame.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';
import 'package:going_wild/ui/game/unit_stage/performance/ability_cast.dart';
import 'package:going_wild/ui/game/unit_stage/performance/ability_performance.dart';
import 'package:going_wild/ui/game/unit_stage/unit/unit_direction.dart';
import 'package:going_wild/ui/game/unit_stage/unit/unit_sprite.dart';
import 'package:going_wild/ui/game/unit_stage/unit_stage.dart';
import 'package:going_wild/ui/game/unit_stage/unit_stage_game.dart';
import 'package:going_wild/ui/game/widgets/board_scene/board_scene_layout.dart';

const _lookaheadTicks = 30;
const _slideSeconds = 0.4;
const _meleeImpactSeconds = 0.36;
const _rangedImpactSeconds = 0.58;
const _shortestLateWalkSeconds = 0.45;

typedef _Cue = void Function(int firingTick);

class FieldStage extends UnitStageGame {
  FieldStage({required this.board, required this.rules}) : super(boardRegion: Offset.zero & BoardSceneLayout.imageSize);

  final Board board;
  final CombatRules rules;
  final unitPoints = ValueNotifier<Map<int, Offset>>(const {});

  final _unitsById = <int, UnitSprite>{};
  final _performancesByCasterId = <int, AbilityPerformance>{};
  final _cuesByTick = SplayTreeMap<int, List<_Cue>>();

  CombatReplay? _replay;
  int _scheduledThroughTick = -1;

  void standStill(Iterable<CombatReplayCombatant> combatants, {Set<int> hiddenIds = const {}}) {
    stage.timeScale = 1;
    _forgetReplay();

    _keepOnly(combatants);
    for (final combatant in combatants) {
      final unit = _unitOf(combatant);
      final cellCenter = _cellCenterOf(combatant.position).toVector2();
      if (unit.position != cellCenter) unit.teleportTo(cellCenter);

      unit
        ..rest()
        ..facing = _restingDirectionOf(combatant.faction);
      hiddenIds.contains(combatant.id) ? unit.fade(this, 0) : unit.release(this);
    }
  }

  void followPlayback(CombatReplay replay, {required int currentTick, required double timeScale}) {
    if (!identical(replay, _replay)) {
      _forgetReplay();
      _replay = replay;
    }

    stage.timeScale = timeScale;
    for (final combatant in replay.frameAt(currentTick).combatants) {
      if (combatant.isAlive) _unitOf(combatant);
    }

    _scheduleThrough(min(replay.lastTick, currentTick + _lookaheadTicks), replay: replay);
    _fireCuesThrough(currentTick);
    _lookAtTargets(replay.frameAt(currentTick));
  }

  void _lookAtTargets(CombatReplayFrame frame) {
    for (final combatant in frame.combatants) {
      final target = _unitsById[combatant.targetCombatantId];
      if (combatant.isAlive && target != null) _unitsById[combatant.id]?.keepEyeOn(target.destination);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    final points = {
      for (final MapEntry(key: id, value: unit) in _unitsById.entries)
        if (unit.isLoaded && unit.opacity > 0) id: unit.stagePoint,
    };
    if (!mapEquals(points, unitPoints.value)) unitPoints.value = Map.unmodifiable(points);
  }

  void _forgetReplay() {
    _replay = null;
    _scheduledThroughTick = -1;
    _cuesByTick.clear();
    for (final performance in _performancesByCasterId.values.toList()) {
      performance.removeFromParent();
    }
  }

  void _keepOnly(Iterable<CombatReplayCombatant> combatants) {
    final characterById = {for (final combatant in combatants) combatant.id: combatant.characterCopy.character};

    _unitsById.removeWhere((id, unit) {
      final isKept = characterById[id] == unit.character && !unit.isDying;
      if (!isKept) unit.removeFromParent();
      return !isKept;
    });
  }

  UnitSprite _unitOf(CombatReplayCombatant combatant) => _unitsById[combatant.id] ??= stage.addUnit(
    at: _cellCenterOf(combatant.position),
    isRanged: combatant.isRanged,
    character: combatant.characterCopy.character,
    facing: _restingDirectionOf(combatant.faction),
  );

  void _scheduleThrough(int lastTick, {required CombatReplay replay}) {
    for (var tick = _scheduledThroughTick + 1; tick <= lastTick; tick++) {
      final entries = replay.entriesAt(tick);
      final frame = replay.frameAt(tick);
      final shownAtTick = tick + 1;

      for (final cast in entries.whereType<AbilityCastHistoryEntry>()) {
        _scheduleAbility(cast, frame: frame, sameTickEntries: entries, shownAtTick: shownAtTick);
      }
      for (final movement in entries.whereType<MovementHistoryEntry>()) {
        _scheduleMovement(movement, replay: replay, frame: frame, shownAtTick: shownAtTick);
      }
      for (final attack in entries.whereType<AttackLandedHistoryEntry>()) {
        _scheduleAttack(attack, frame: frame, shownAtTick: shownAtTick);
      }
      for (final death in entries.whereType<DeathHistoryEntry>()) {
        _cue(shownAtTick, (firingTick) => _unitsById.remove(death.combatantId)?.die());
      }
    }

    _scheduledThroughTick = max(_scheduledThroughTick, lastTick);
  }

  void _cue(int tick, _Cue cue) => _cuesByTick.putIfAbsent(tick, () => []).add(cue);

  void _fireCuesThrough(int currentTick) {
    while (_cuesByTick.isNotEmpty && _cuesByTick.firstKey()! <= currentTick) {
      for (final cue in _cuesByTick.remove(_cuesByTick.firstKey())!) {
        cue(currentTick);
      }
    }
  }

  int _ticksIn(double seconds) => (seconds * rules.ticksPerSecond).round();
  double _secondsUntil(int tick, {required int from}) => max(1, tick - from) / rules.ticksPerSecond;

  void _scheduleMovement(
    MovementHistoryEntry movement, {
    required CombatReplay replay,
    required CombatReplayFrame frame,
    required int shownAtTick,
  }) {
    final destination = _cellCenterOf(movement.toPosition).toVector2();

    switch (movement.cause) {
      case MovementTowardTargetHistoryCause():
        final walker = _combatantIn(frame, id: movement.combatantId);
        if (walker == null) return;

        final walkTicks = rules.ticksBetweenSteps(walker.currentStats[Stat.moveSpeed]);
        final walkSeconds = walkTicks / rules.ticksPerSecond;
        _cue(shownAtTick - walkTicks, (firingTick) {
          final seconds = max(_secondsUntil(shownAtTick, from: firingTick), min(walkSeconds, _shortestLateWalkSeconds));
          _unitsById[movement.combatantId]?.walkTo(destination, seconds: seconds);
        });
      case AbilityHistoryCause():
        return;
      case LastingEffectsTickHistoryCause(:final ownerCombatantId):
        final targetId = _combatantIn(replay.frameAt(shownAtTick), id: movement.combatantId)?.targetCombatantId;
        _cue(shownAtTick, (firingTick) {
          final unit = _unitsById[movement.combatantId];
          if (unit == null) return;

          final performance = _performancesByCasterId[ownerCombatantId];
          if (performance == null) return unit.teleportTo(destination);
          performance.relocate(unit, destination.toOffset(), facingToward: _unitsById[targetId]);
        });
      case _:
        _cue(shownAtTick - _ticksIn(_slideSeconds), (firingTick) {
          _unitsById[movement.combatantId]?.slideTo(destination, seconds: _secondsUntil(shownAtTick, from: firingTick));
        });
    }
  }

  void _scheduleAttack(AttackLandedHistoryEntry attack, {required CombatReplayFrame frame, required int shownAtTick}) {
    final attacker = _combatantIn(frame, id: attack.combatantId);
    if (attacker == null) return;

    final impactSeconds = attacker.isRanged ? _rangedImpactSeconds : _meleeImpactSeconds;
    _cue(shownAtTick - _ticksIn(impactSeconds), (firingTick) {
      final attackerUnit = _unitsById[attack.combatantId];
      final targetUnit = _unitsById[attack.targetCombatantId];
      if (attackerUnit == null || targetUnit == null || !attackerUnit.isLoaded || !targetUnit.isLoaded) return;

      stage.attack(attackerUnit, toward: targetUnit.destination, aim: UnitStage.aimAt(targetUnit));
    });
  }

  void _scheduleAbility(
    AbilityCastHistoryEntry cast, {
    required CombatReplayFrame frame,
    required int shownAtTick,
    required List<CombatHistoryEntry> sameTickEntries,
  }) {
    final casterCombatant = _combatantIn(frame, id: cast.combatantId);
    if (casterCombatant == null) return;

    final relocations = {
      for (final movement in sameTickEntries.whereType<MovementHistoryEntry>())
        if (movement.cause case AbilityHistoryCause(:final casterCombatantId) when casterCombatantId == cast.combatantId)
          movement.combatantId: _cellCenterOf(movement.toPosition),
    };

    final visuals = casterCombatant.characterCopy.character.sprite.abilityVisuals;
    final leadTicks = _ticksIn(AbilityPerformance.secondsUntilEffectOf(visuals));

    _cue(shownAtTick - leadTicks, (firingTick) {
      final performance = _perform(cast, casterCombatant: casterCombatant, frame: frame, relocations: relocations);
      if (performance != null) return;

      for (final MapEntry(key: id, value: destination) in relocations.entries) {
        _unitsById[id]?.teleportTo(destination.toVector2());
      }
    });
  }

  AbilityPerformance? _perform(
    AbilityCastHistoryEntry cast, {
    required CombatReplayFrame frame,
    required Map<int, Offset> relocations,
    required CombatReplayCombatant casterCombatant,
  }) {
    final caster = _unitsById[cast.combatantId];
    if (caster == null) return null;

    final affectedIds = cast.affectedCombatantIds.toSet();
    final living = [
      for (final combatant in frame.combatants)
        if (combatant.isAlive && _unitsById[combatant.id] != null) combatant,
    ];
    final allies = living.where((combatant) => combatant.faction == casterCombatant.faction && combatant.id != casterCombatant.id).toList()
      ..sort((first, second) => _allyOrder(first, second, affectedIds: affectedIds, caster: casterCombatant));
    final enemies = living.where((combatant) => combatant.faction != casterCombatant.faction).toList();
    final affectedEnemies = enemies.where((enemy) => affectedIds.contains(enemy.id)).toList();

    final targetId = affectedEnemies.firstOrNull?.id ?? casterCombatant.targetCombatantId;
    final target = _unitsById[targetId] ?? caster;

    final performance = stage.perform(
      AbilityCast(
        caster: caster,
        target: target,
        allies: [for (final ally in allies) _unitsById[ally.id]!],
        enemies: [for (final enemy in enemies) _unitsById[enemy.id]!],
        struckEnemies: {
          if (target != caster) target,
          for (final enemy in affectedEnemies) _unitsById[enemy.id]!,
        }.toList(),
        relocations: {
          for (final MapEntry(key: id, value: destination) in relocations.entries) ?_unitsById[id]: destination,
        },
      ),
    );
    if (performance == null) return null;

    _performancesByCasterId[cast.combatantId]?.removeFromParent();
    _performancesByCasterId[cast.combatantId] = performance;
    performance.removed.then((_) {
      if (_performancesByCasterId[cast.combatantId] == performance) _performancesByCasterId.remove(cast.combatantId);
    });

    return performance;
  }

  int _allyOrder(
    CombatReplayCombatant first,
    CombatReplayCombatant second, {
    required Set<int> affectedIds,
    required CombatReplayCombatant caster,
  }) {
    final affectedOrder = (affectedIds.contains(first.id) ? 0 : 1).compareTo(affectedIds.contains(second.id) ? 0 : 1);
    if (affectedOrder != 0) return affectedOrder;

    return first.position.distanceToPosition(caster.position).compareTo(second.position.distanceToPosition(caster.position));
  }

  CombatReplayCombatant? _combatantIn(CombatReplayFrame frame, {required int id}) =>
      frame.combatants.where((combatant) => combatant.id == id).firstOrNull;

  Offset _cellCenterOf(Position position) => BoardSceneLayout.cellRectOf(board, position, scale: 1).center;

  static UnitDirection _restingDirectionOf(Faction faction) => faction == Faction.team ? UnitDirection.backRight : UnitDirection.frontRight;
}
