import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stat_change_type.dart';
import 'package:going_wild/domain/models/character/stats/stat_modification.dart';
import 'package:going_wild/domain/models/combat/combatant_actions/attack_target.dart';
import 'package:going_wild/domain/models/combat/combatant_actions/deal_damage.dart';
import 'package:going_wild/domain/models/combatant/capabilities/gain_mana.dart';
import 'package:going_wild/domain/models/combatant/capabilities/take_damage.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_target.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/damage/damage_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/next_hits_stat_modifier/next_hits_stat_modifier_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/shield/shield_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stun/stun_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';

import '../../../helpers/combat_helpers.dart';

void main() {
  test('armor: 50 removes a third, 100 removes half, never everything', () {
    expect(reduceDamageByArmor(120, 0), 120);
    expect(reduceDamageByArmor(120, 50), closeTo(80, 0.001));
    expect(reduceDamageByArmor(120, 100), 60);
    expect(reduceDamageByArmor(120, 10000), greaterThan(0));
  });

  test('damageTakenPercentage scales the damage after armor', () {
    final target = combatant(
      at: at(1, 0),
      faction: Faction.team,
      stats: statsOf(armor: 100, health: 1000, damageTakenPercentage: 0.5),
    );

    final damagedCombat = dealDamageToCombatant(combatWith([target]), damageAmount: 200, targetCombatantId: target.id);

    expect(findCombatant(damagedCombat, target).currentHealth, 1000 - 50);
  });

  test('shield absorbs before health and schedules its expiration effects when it breaks', () {
    final onExpireEffects = [DamageEffect(value: atEveryStar(10), target: CombatEffectTarget.nearbyEnemies)];
    final target = withCombatLastingEffects(combatant(at: at(1, 0), faction: Faction.team), [
      ShieldCombatLastingEffect(remainingTicks: 50, remainingShield: 60, sourceCombatantId: 99, onExpire: onExpireEffects),
    ]);

    final damagedCombat = dealDamageToCombatant(combatWith([target]), damageAmount: 100, targetCombatantId: target.id);
    final damagedTarget = findCombatant(damagedCombat, target);

    expect(damagedTarget.currentHealth, 1000 - 40);
    expect(damagedTarget.currentShield, 0);
    expect(damagedTarget.combatLastingEffects, isEmpty);
    expect(damagedCombat.pendingCombatEffectApplications.single.sourceCombatantId, 99);
    expect(damagedCombat.pendingCombatEffectApplications.single.effects, onExpireEffects);
  });

  test('a shield that is not spent keeps the leftover and schedules nothing', () {
    final target = withCombatLastingEffects(combatant(at: at(1, 0), faction: Faction.team), [
      const ShieldCombatLastingEffect(onExpire: [], remainingTicks: 50, remainingShield: 60, sourceCombatantId: 99),
    ]);

    final damagedCombat = dealDamageToCombatant(combatWith([target]), damageAmount: 20, targetCombatantId: target.id);
    final damagedTarget = findCombatant(damagedCombat, target);

    expect(damagedTarget.currentHealth, 1000);
    expect(damagedTarget.currentShield, 40);
    expect(damagedCombat.pendingCombatEffectApplications, isEmpty);
  });

  test('a lethal hit floors health at zero and clears the lasting effects', () {
    final target = withCombatLastingEffects(combatant(at: at(1, 0), faction: Faction.team, stats: statsOf(health: 30)), [
      const StunCombatLastingEffect(remainingTicks: 30, sourceCombatantId: 99),
    ]);

    final damagedCombat = dealDamageToCombatant(combatWith([target]), damageAmount: 100, targetCombatantId: target.id);
    final damagedTarget = findCombatant(damagedCombat, target);

    expect(damagedTarget.currentHealth, 0);
    expect(damagedTarget.isAlive, isFalse);
    expect(damagedTarget.combatLastingEffects, isEmpty);
  });

  test('dead combatants take no more damage', () {
    final deadTarget = combatant(at: at(1, 0), faction: Faction.team).createCopyWith(currentHealth: 0);

    final damageTaken = takeDamage(deadTarget, damageAmount: 100);

    expect(damageTaken.damagedCombatant, same(deadTarget));
    expect(damageTaken.brokenCombatLastingEffects, isEmpty);
  });

  test('mana gain is capped at manaMax', () {
    final caster = combatant(at: at(0, 0), faction: Faction.team, stats: statsOf(manaMax: 50));

    final fullManaCaster = gainMana(gainMana(caster, manaAmount: 30), manaAmount: 30);

    expect(fullManaCaster.currentMana, 50);
    expect(gainMana(fullManaCaster, manaAmount: 10), same(fullManaCaster));
  });

  test('attacks once per 1 / attackSpeed seconds and grants mana per hit', () {
    final enemy = combatant(at: at(0, 0), faction: Faction.enemy, stats: statsOf(health: 10000));
    final attacker = combatant(
      at: at(1, 0),
      faction: Faction.team,
      stats: statsOf(manaMax: 100, attackSpeed: 2),
    ).createCopyWith(targetCombatantId: enemy.id);
    var combat = combatWith([attacker, enemy]);

    for (var tick = 0; tick < testRules.ticksPerSecond; tick++) {
      combat = attackTarget(combat, attacker.id);
    }

    expect(findCombatant(combat, enemy).currentHealth, 10000 - 2 * 100);
    expect(findCombatant(combat, attacker).currentMana, 2 * testRules.manaPerHit);
  });

  test('a whole number of seconds between attacks becomes an exact number of ticks', () {
    final enemy = combatant(at: at(0, 0), faction: Faction.enemy, stats: statsOf(health: 10000));
    final attacker = combatant(
      at: at(1, 0),
      faction: Faction.team,
      stats: statsOf(attackSpeed: 1),
    ).createCopyWith(targetCombatantId: enemy.id);
    var combat = combatWith([attacker, enemy]);

    for (var tick = 0; tick <= 2 * testRules.ticksPerSecond; tick++) {
      combat = attackTarget(combat, attacker.id);
    }

    expect(findCombatant(combat, enemy).currentHealth, 10000 - 3 * 100);
  });

  test('does not attack out of range', () {
    final enemy = combatant(at: at(0, 0), faction: Faction.enemy);
    final attacker = combatant(at: at(3, 0), faction: Faction.team).createCopyWith(targetCombatantId: enemy.id);
    final combat = combatWith([attacker, enemy]);

    expect(attackTarget(combat, attacker.id), same(combat));
  });

  test('does not attack a dead target', () {
    final deadEnemy = combatant(at: at(0, 0), faction: Faction.enemy).createCopyWith(currentHealth: 0);
    final attacker = combatant(at: at(1, 0), faction: Faction.team).createCopyWith(targetCombatantId: deadEnemy.id);
    final combat = combatWith([attacker, deadEnemy]);

    expect(attackTarget(combat, attacker.id), same(combat));
  });

  test('next hits modifiers are consumed by attacks', () {
    final enemy = combatant(at: at(0, 0), faction: Faction.enemy, stats: statsOf(health: 10000));
    final attacker = withCombatLastingEffects(
      combatant(
        at: at(1, 0),
        faction: Faction.team,
        stats: statsOf(damage: 10, attackSpeed: 100),
      ).createCopyWith(targetCombatantId: enemy.id),
      [
        const NextHitsStatModifierCombatLastingEffect(
          remainingHits: 1,
          sourceCombatantId: 99,
          statModification: StatModification(value: 90, stat: Stat.damage, changeType: StatChangeType.absoluteValue),
        ),
      ],
    );

    final firstAttackCombat = attackTarget(combatWith([attacker, enemy]), attacker.id);
    final secondAttackCombat = attackTarget(firstAttackCombat, attacker.id);

    expect(findCombatant(firstAttackCombat, enemy).currentHealth, 10000 - 100);
    expect(findCombatant(secondAttackCombat, enemy).currentHealth, 10000 - 100 - 10);
    expect(findCombatant(secondAttackCombat, attacker).combatLastingEffects, isEmpty);
  });
}
