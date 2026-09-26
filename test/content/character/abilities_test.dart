import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/enemies/enemies.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/stars/star_values.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stat_change_type.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_target.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/targeted_combat_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/ambush/ambush_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/damage/damage_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/damage_over_time/damage_over_time_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/heal_over_time/heal_over_time_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/knockback/knockback_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/lifesteal/lifesteal_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/mana_refund_on_kill/mana_refund_on_kill_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/next_hits_stat_modifier/next_hits_stat_modifier_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/pull/pull_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/shield/shield_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stat_modifier/stat_modifier_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stun/stun_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/taunt/taunt_effect.dart';

const allCharacters = [...allTeamCharacters, ...allEnemyCharacters];

const enemyTargets = {
  CombatEffectTarget.focus,
  CombatEffectTarget.allEnemies,
  CombatEffectTarget.farthestEnemy,
  CombatEffectTarget.nearbyEnemies,
  CombatEffectTarget.lowestHealthEnemy,
  CombatEffectTarget.enemiesAroundFocus,
};

const areaTargets = {CombatEffectTarget.allEnemies, CombatEffectTarget.nearbyEnemies, CombatEffectTarget.enemiesAroundFocus};

List<CombatEffect> combatEffectsOf(Character character) => character.ability.effects.whereType<CombatEffect>().toList();

Iterable<CombatEffect> flatten(Iterable<CombatEffect> effects) sync* {
  for (final effect in effects) {
    yield effect;
    if (effect is ShieldEffect) yield* flatten(effect.onExpire);
  }
}

List<StarValues> starValuesOf(CombatEffect effect) => switch (effect) {
  DamageEffect() => [effect.value],
  DamageOverTimeEffect() => [effect.damagePerSecond, effect.seconds],
  HealOverTimeEffect() => [effect.healPerSecond, effect.seconds],
  ShieldEffect() => [effect.value, effect.seconds],
  StunEffect() => [effect.seconds],
  TauntEffect() => [effect.seconds],
  KnockbackEffect() => [],
  StatModifierEffect() => [effect.value, effect.seconds],
  NextHitsStatModifierEffect() => [effect.value],
  ManaRefundOnKillEffect() => [],
  LifestealEffect() => [effect.value],
  PullEffect() => [],
  AmbushEffect() => [effect.seconds],
  _ => fail('the abilities test does not know the star values of ${effect.runtimeType}'),
};

bool isMovingEffect(CombatEffect effect) => effect is KnockbackEffect || effect is PullEffect;

bool isAreaEffect(CombatEffect effect) => effect is TargetedCombatEffect && areaTargets.contains(effect.target);

void main() {
  test('every ability has at least one combat effect', () {
    for (final character in allCharacters) {
      expect(combatEffectsOf(character), isNotEmpty, reason: character.id.value);
    }
  });

  test('mana starts below max', () {
    for (final character in allCharacters) {
      final manaStart = character.statMultipliers[Stat.manaStart];

      expect(manaStart, lessThan(character.statMultipliers[Stat.manaMax]), reason: character.id.value);
      expect(manaStart, greaterThanOrEqualTo(0), reason: character.id.value);
    }
  });

  test('star values are positive and never shrink with stars', () {
    for (final character in allCharacters) {
      for (final effect in flatten(combatEffectsOf(character))) {
        final reason = '${character.id.value} ${effect.runtimeType}';

        for (final starValues in starValuesOf(effect)) {
          expect(starValues.star1, greaterThan(0), reason: reason);
          expect(starValues.star2, greaterThanOrEqualTo(starValues.star1), reason: reason);
          expect(starValues.star3, greaterThanOrEqualTo(starValues.star2), reason: reason);
        }
      }
    }
  });

  test('stat modifiers weaken enemies and strengthen allies', () {
    for (final character in allCharacters) {
      for (final effect in flatten(combatEffectsOf(character)).whereType<StatModifierEffect>()) {
        final isOnEnemies = enemyTargets.contains(effect.target);
        final isMultiplier = effect.changeType == StatChangeType.multiplier;
        final neutralValue = isMultiplier ? 1 : 0;
        final expectedValue = isOnEnemies ? lessThan(neutralValue) : greaterThan(neutralValue);

        expect(effect.value.star1, expectedValue, reason: '${character.id.value} ${effect.stat.name}');
      }
    }
  });

  test('knockbacks move at least one cell and refunds are a valid percentage', () {
    for (final character in allCharacters) {
      for (final effect in flatten(combatEffectsOf(character))) {
        if (effect is KnockbackEffect) expect(effect.cells, greaterThanOrEqualTo(1), reason: character.id.value);
        if (effect is ManaRefundOnKillEffect) expect(effect.percentage, inInclusiveRange(1, 100), reason: character.id.value);
      }
    }
  });

  test('effects that move targets come after every area effect of the same ability', () {
    for (final character in allCharacters) {
      final effects = combatEffectsOf(character);
      final firstMovingIndex = effects.indexWhere(isMovingEffect);
      if (firstMovingIndex == -1) continue;

      final areaEffectsAfterMoving = effects.skip(firstMovingIndex + 1).where(isAreaEffect);
      expect(areaEffectsAfterMoving, isEmpty, reason: character.id.value);
    }
  });

  test('every character defines every stat explicitly', () {
    for (final character in allCharacters) {
      expect(character.statMultipliers.definedStats, Stat.values.toSet(), reason: character.id.value);
    }
  });

  test('multipliers are positive and range is 1, 2 or 4 cells', () {
    for (final character in allCharacters) {
      for (final stat in Stat.values.where((stat) => stat != Stat.manaStart)) {
        expect(character.statMultipliers[stat], greaterThan(0), reason: '${character.id.value} $stat');
      }

      expect([1, 2, 4], contains(character.statMultipliers[Stat.range]), reason: character.id.value);
    }
  });
}
