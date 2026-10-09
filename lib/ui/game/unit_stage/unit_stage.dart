import 'dart:ui';

import 'package:flame/components.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/ui/game/unit_stage/effects/action/thrown_pebble.dart';
import 'package:going_wild/ui/game/unit_stage/performance/ability_cast.dart';
import 'package:going_wild/ui/game/unit_stage/performance/ability_performance.dart';
import 'package:going_wild/ui/game/unit_stage/unit/unit_direction.dart';
import 'package:going_wild/ui/game/unit_stage/unit/unit_sprite.dart';

const _bodyHeightShare = 0.55;
const _targetHeightShare = 0.45;

class UnitStage extends World {
  UnitStage() {
    addAll([ground, units, overlay]);
  }

  final ground = Component(priority: 0);
  final units = Component(priority: 1);
  final overlay = Component(priority: 2);

  double timeScale = 1;

  @override
  void updateTree(double dt) => super.updateTree(dt * timeScale);

  UnitSprite addUnit({
    required Offset at,
    required bool isRanged,
    required Character character,
    required UnitDirection facing,
  }) {
    final unit = UnitSprite(character: character, isRanged: isRanged, facing: facing, position: Vector2(at.dx, at.dy));
    units.add(unit);
    ground.add(unit.shadow);
    return unit;
  }

  void attack(UnitSprite attacker, {required Offset toward, required Offset aim}) {
    attacker.attack(
      toward,
      onRelease: attacker.isRanged ? () => throwPebble(from: attacker, aim: aim) : null,
    );
  }

  void throwPebble({required UnitSprite from, required Offset aim}) {
    if (!from.isLoaded) return;
    overlay.add(ThrownPebble(from: Offset(from.stagePoint.dx, from.footY - from.heightAboveFoot * _bodyHeightShare), to: aim));
  }

  static Offset aimAt(UnitSprite target) => target.destination + Offset(0, footDrop - target.heightAboveFoot * _targetHeightShare);

  AbilityPerformance? perform(AbilityCast cast) {
    if (!cast.caster.isLoaded || !cast.target.isLoaded) return null;

    final performance = AbilityPerformance(cast: cast, stage: this);
    overlay.add(performance);
    return performance;
  }
}
