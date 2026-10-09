import 'dart:ui';

import 'package:going_wild/domain/models/character/sprite/hex_effect.dart';
import 'package:going_wild/ui/game/unit_stage/unit/unit_sprite.dart';

class AbilityCast {
  const AbilityCast({
    required this.caster,
    required this.target,
    required this.allies,
    required this.enemies,
    required this.struckEnemies,
    this.relocations = const {},
  });

  final UnitSprite caster;
  final UnitSprite target;
  final List<UnitSprite> allies;
  final List<UnitSprite> enemies;
  final List<UnitSprite> struckEnemies;
  final Map<UnitSprite, Offset> relocations;

  HexEffect? get hexEffect => caster.sprite.abilityVisuals.hexEffect;

  List<UnitSprite> get hexTargets {
    final hexEffect = this.hexEffect;
    if (hexEffect == null) return const [];

    final targets = hexEffect.targets;
    return {
      if (targets.contains(HexEffectTarget.self)) caster,
      if (targets.contains(HexEffectTarget.allies))
        ...switch (hexEffect.scope) {
          HexEffectScope.target => allies.take(1),
          HexEffectScope.targetAndNeighbors || HexEffectScope.all => allies,
        },
      if (targets.contains(HexEffectTarget.enemies))
        ...switch (hexEffect.scope) {
          HexEffectScope.target => [target],
          HexEffectScope.targetAndNeighbors => struckEnemies,
          HexEffectScope.all => enemies,
        },
    }.toList();
  }

  List<UnitSprite> get struckUnits {
    final reachesEnemies = hexEffect?.targets.contains(HexEffectTarget.enemies) ?? false;
    if (!reachesEnemies) return [target];

    final hexTargets = this.hexTargets;
    final struckUnits = enemies.where(hexTargets.contains).toList();
    return struckUnits.isEmpty ? [target] : struckUnits;
  }
}
