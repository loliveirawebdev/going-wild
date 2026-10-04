import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stat_change_type.dart';
import 'package:going_wild/domain/models/character/stats/stat_modification.dart';
import 'package:going_wild/domain/models/combat/combatant_actions/cast_ability_if_ready.dart';
import 'package:going_wild/domain/models/combatant/ability_triggers/low_health_trigger.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/ambush/ambush_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/ambush/vanished_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/damage/damage_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/damage_over_time/damage_over_time_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/damage_over_time/damage_over_time_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/heal_over_time/heal_over_time_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/heal_over_time/heal_over_time_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/knockback/knockback_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/lifesteal/lifesteal_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/mana_refund_on_kill/mana_refund_on_kill_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/next_hits_stat_modifier/next_hits_stat_modifier_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/next_hits_stat_modifier/next_hits_stat_modifier_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/pull/pull_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/shield/shield_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/shield/shield_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stat_modifier/stat_modifier_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stat_modifier/stat_modifier_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stun/stun_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stun/stun_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/taunt/taunt_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/taunt/taunt_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/all_enemies_target.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/enemies_around_focus_target.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/farthest_enemy_target.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/focus_target.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/lowest_health_enemy_target.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/nearby_allies_target.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/self_target.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';

import '../../../helpers/combat_helpers.dart';

void main() {
  test('casts when mana is full and resets mana to zero', () {
    final enemy = combatant(at: at(0, 0), faction: Faction.enemy);
    final caster = combatant(
      at: at(1, 0),
      faction: Faction.team,
      stats: statsOf(manaMax: 50, manaStart: 50),
      character: dummy(
        ability: ability([DamageEffect(value: atEveryStar(300), target: const FocusTarget())]),
      ),
    ).createCopyWith(targetCombatantId: enemy.id);

    final castCombat = castAbilityIfReady(combatWith([caster, enemy]), caster.id);

    expect(findCombatant(castCombat, caster).currentMana, 0);
    expect(findCombatant(castCombat, enemy).currentHealth, 700);
  });

  test('does not cast below full mana', () {
    final caster = combatant(
      at: at(1, 0),
      faction: Faction.team,
      stats: statsOf(manaMax: 50, manaStart: 49),
      character: dummy(
        ability: ability([DamageEffect(value: atEveryStar(300), target: const FocusTarget())]),
      ),
    );
    final combat = combatWith([caster]);

    expect(castAbilityIfReady(combat, caster.id), same(combat));
  });

  test('low health trigger fires once, at or below the threshold', () {
    final caster = combatant(
      at: at(1, 0),
      faction: Faction.team,
      stats: statsOf(health: 100),
      character: dummy(
        ability: ability(
          [
            StatModifierEffect(
              stat: Stat.armor,
              value: atEveryStar(50),
              seconds: atEveryStar(3),
              target: const SelfTarget(),
              changeType: StatChangeType.absoluteValue,
            ),
          ],
          trigger: const LowHealthTrigger(healthPercentage: 30),
        ),
      ),
    );

    final combatAboveThreshold = combatWith([caster.createCopyWith(currentHealth: 31)]);
    expect(castAbilityIfReady(combatAboveThreshold, caster.id), same(combatAboveThreshold));

    final firstCastCombat = castAbilityIfReady(combatWith([caster.createCopyWith(currentHealth: 30)]), caster.id);
    final secondCastCombat = castAbilityIfReady(firstCastCombat, caster.id);

    expect(findCombatant(firstCastCombat, caster).abilityCastCount, 1);
    expect(findCombatant(firstCastCombat, caster).getCurrentStat(Stat.armor), 50);
    expect(secondCastCombat, same(firstCastCombat));
  });

  test('each low health trigger fires at its own health percentage', () {
    Combatant casterWithThreshold(double healthPercentage) => combatant(
      at: at(7, 2),
      faction: Faction.team,
      stats: statsOf(health: 100),
      character: dummy(
        ability: ability(
          [StunEffect(target: const SelfTarget(), seconds: atEveryStar(1))],
          trigger: LowHealthTrigger(healthPercentage: healthPercentage),
        ),
      ),
    ).createCopyWith(currentHealth: 45);

    final cautiousCaster = casterWithThreshold(50);
    final braveCaster = casterWithThreshold(30);

    final cautiousCombat = combatWith([cautiousCaster]);
    final braveCombat = combatWith([braveCaster]);

    expect(findCombatant(castAbilityIfReady(cautiousCombat, cautiousCaster.id), cautiousCaster).abilityCastCount, 1);
    expect(castAbilityIfReady(braveCombat, braveCaster.id), same(braveCombat));
  });

  test('taunt makes targets attack the caster', () {
    final caster = combatant(
      at: at(4, 2),
      faction: Faction.team,
      stats: statsOf(manaStart: 50),
      character: dummy(
        ability: ability([TauntEffect(seconds: atEveryStar(2), target: const AllEnemiesTarget())]),
      ),
    );
    final firstEnemy = combatant(at: at(0, 0), faction: Faction.enemy);
    final secondEnemy = combatant(at: at(0, 4), faction: Faction.enemy);

    final castCombat = castAbilityIfReady(combatWith([caster, firstEnemy, secondEnemy]), caster.id);

    expect(findCombatant(castCombat, firstEnemy).targetCombatantId, caster.id);
    expect(findCombatant(castCombat, secondEnemy).targetCombatantId, caster.id);
    expect(
      findCombatant(castCombat, firstEnemy).combatLastingEffects.whereType<TauntCombatLastingEffect>().single.sourceCombatantId,
      caster.id,
    );
  });

  test('a taunted target ignores a second taunt', () {
    final caster = combatant(
      at: at(4, 2),
      faction: Faction.team,
      stats: statsOf(manaStart: 50),
      character: dummy(
        ability: ability([TauntEffect(seconds: atEveryStar(2), target: const AllEnemiesTarget())]),
      ),
    );
    final firstTaunter = combatant(at: at(7, 0), faction: Faction.team);
    final enemy = withCombatLastingEffects(combatant(at: at(0, 0), faction: Faction.enemy), [
      TauntCombatLastingEffect(remainingTicks: 10, sourceCombatantId: firstTaunter.id),
    ]).createCopyWith(targetCombatantId: firstTaunter.id);

    final castCombat = castAbilityIfReady(combatWith([caster, firstTaunter, enemy]), caster.id);

    expect(findCombatant(castCombat, enemy).targetCombatantId, firstTaunter.id);
    expect(findCombatant(castCombat, enemy).combatLastingEffects.single, isA<TauntCombatLastingEffect>());
  });

  test('a stunned target ignores a new stun', () {
    final enemy = withCombatLastingEffects(combatant(at: at(0, 0), faction: Faction.enemy), [
      const StunCombatLastingEffect(remainingTicks: 30, sourceCombatantId: 99),
    ]);
    final caster = combatant(
      at: at(1, 0),
      faction: Faction.team,
      stats: statsOf(manaStart: 50),
      character: dummy(
        ability: ability([StunEffect(seconds: atEveryStar(1), target: const FocusTarget())]),
      ),
    ).createCopyWith(targetCombatantId: enemy.id);

    final castCombat = castAbilityIfReady(combatWith([caster, enemy]), caster.id);
    final stuns = findCombatant(castCombat, enemy).combatLastingEffects.whereType<StunCombatLastingEffect>();

    expect(stuns.single.remainingTicks, 30);
    expect(stuns.single.sourceCombatantId, 99);
  });

  test('the same stat modification is ignored instead of stacking or renewing', () {
    const doubleDamage = StatModification(value: 2, stat: Stat.damage, changeType: StatChangeType.multiplier);
    final caster = withCombatLastingEffects(
      combatant(
        at: at(1, 0),
        faction: Faction.team,
        stats: statsOf(manaMax: 50, manaStart: 50),
        character: dummy(
          ability: ability([
            StatModifierEffect(
              stat: Stat.damage,
              value: atEveryStar(2),
              seconds: atEveryStar(3),
              target: const SelfTarget(),
              changeType: StatChangeType.multiplier,
            ),
          ]),
        ),
      ),
      [const StatModifierCombatLastingEffect(remainingTicks: 5, sourceCombatantId: 99, statModification: doubleDamage)],
    );

    final castCombat = castAbilityIfReady(combatWith([caster]), caster.id);
    final statModifiers = findCombatant(castCombat, caster).combatLastingEffects.whereType<StatModifierCombatLastingEffect>();

    expect(statModifiers.single.remainingTicks, 5);
    expect(findCombatant(castCombat, caster).getCurrentStat(Stat.damage), 200);
  });

  test('a different stat modification on the same stat stacks', () {
    const halfDamage = StatModification(value: 0.5, stat: Stat.damage, changeType: StatChangeType.multiplier);
    final caster = withCombatLastingEffects(
      combatant(
        at: at(1, 0),
        faction: Faction.team,
        stats: statsOf(manaMax: 50, manaStart: 50),
        character: dummy(
          ability: ability([
            StatModifierEffect(
              stat: Stat.damage,
              value: atEveryStar(3),
              seconds: atEveryStar(3),
              target: const SelfTarget(),
              changeType: StatChangeType.multiplier,
            ),
          ]),
        ),
      ),
      [const StatModifierCombatLastingEffect(remainingTicks: 10, sourceCombatantId: 99, statModification: halfDamage)],
    );

    final castCombat = castAbilityIfReady(combatWith([caster]), caster.id);

    expect(findCombatant(castCombat, caster).combatLastingEffects.whereType<StatModifierCombatLastingEffect>(), hasLength(2));
    expect(findCombatant(castCombat, caster).getCurrentStat(Stat.damage), 150);
  });

  test('the same next hits modification is ignored instead of stacking', () {
    const bonusDamage = StatModification(value: 50, stat: Stat.damage, changeType: StatChangeType.absoluteValue);
    final caster = withCombatLastingEffects(
      combatant(
        at: at(1, 0),
        faction: Faction.team,
        stats: statsOf(manaStart: 50),
        character: dummy(
          ability: ability([
            NextHitsStatModifierEffect(
              hits: 3,
              stat: Stat.damage,
              value: atEveryStar(50),
              target: const SelfTarget(),
              changeType: StatChangeType.absoluteValue,
            ),
          ]),
        ),
      ),
      [const NextHitsStatModifierCombatLastingEffect(remainingHits: 1, sourceCombatantId: 99, statModification: bonusDamage)],
    );

    final castCombat = castAbilityIfReady(combatWith([caster]), caster.id);
    final nextHitsModifiers = findCombatant(castCombat, caster).combatLastingEffects.whereType<NextHitsStatModifierCombatLastingEffect>();

    expect(nextHitsModifiers.single.remainingHits, 1);
  });

  test('knockback pushes away from the caster and stops at the edge', () {
    final enemy = combatant(at: at(1, 2), faction: Faction.enemy);
    final caster = combatant(
      at: at(2, 2),
      faction: Faction.team,
      stats: statsOf(manaStart: 50),
      character: dummy(ability: ability([const KnockbackEffect(cells: 5, target: FocusTarget())])),
    ).createCopyWith(targetCombatantId: enemy.id);

    final castCombat = castAbilityIfReady(combatWith([caster, enemy]), caster.id);

    expect(findCombatant(castCombat, enemy).position, at(0, 2));
  });

  test('knockback pushes the farthest targets first so the ones behind never block the ones in front', () {
    final focus = combatant(faction: Faction.enemy, at: at(3, 2));
    final enemyBehind = combatant(faction: Faction.enemy, at: at(2, 2));
    final caster = combatant(
      at: at(4, 2),
      faction: Faction.team,
      stats: statsOf(manaStart: 50),
      character: dummy(ability: ability([const KnockbackEffect(cells: 1, target: EnemiesAroundFocusTarget())])),
    ).createCopyWith(targetCombatantId: focus.id);

    final castCombat = castAbilityIfReady(combatWith([caster, focus, enemyBehind]), caster.id);

    expect(findCombatant(castCombat, enemyBehind).position, at(1, 2));
    expect(findCombatant(castCombat, focus).position, at(2, 2));
  });

  test('lifesteal heals the caster by the damage dealt', () {
    final enemy = combatant(at: at(0, 0), faction: Faction.enemy, stats: statsOf(armor: 100));
    final caster = combatant(
      at: at(1, 0),
      faction: Faction.team,
      stats: statsOf(health: 1000, manaStart: 50),
      character: dummy(
        ability: ability([LifestealEffect(value: atEveryStar(200), target: const FocusTarget())]),
      ),
    ).createCopyWith(currentHealth: 500, targetCombatantId: enemy.id);

    final castCombat = castAbilityIfReady(combatWith([caster, enemy]), caster.id);

    expect(findCombatant(castCombat, enemy).currentHealth, 900);
    expect(findCombatant(castCombat, caster).currentHealth, 600);
  });

  test('mana refund happens only when the cast kills', () {
    Combatant casterAfterCastAgainst(double enemyHealth) {
      final enemy = combatant(
        at: at(0, 0),
        faction: Faction.enemy,
        stats: statsOf(health: enemyHealth),
      );
      final caster = combatant(
        at: at(1, 0),
        faction: Faction.team,
        stats: statsOf(manaMax: 100, manaStart: 100),
        character: dummy(
          ability: ability([
            DamageEffect(value: atEveryStar(50), target: const FocusTarget()),
            const ManaRefundOnKillEffect(percentage: 50),
          ]),
        ),
      ).createCopyWith(targetCombatantId: enemy.id);

      return findCombatant(castAbilityIfReady(combatWith([caster, enemy]), caster.id), caster);
    }

    expect(casterAfterCastAgainst(40).currentMana, 50);
    expect(casterAfterCastAgainst(400).currentMana, 0);
  });

  test('pull brings the farthest enemy next to the caster', () {
    final caster = combatant(
      at: at(7, 2),
      faction: Faction.team,
      stats: statsOf(manaStart: 50),
      character: dummy(ability: ability([const PullEffect(target: FarthestEnemyTarget())])),
    );
    final nearEnemy = combatant(at: at(5, 2), faction: Faction.enemy);
    final farEnemy = combatant(at: at(0, 0), faction: Faction.enemy);

    final castCombat = castAbilityIfReady(combatWith([caster, nearEnemy, farEnemy]), caster.id);

    expect(findCombatant(castCombat, farEnemy).position.distanceToPosition(caster.position), 1);
    expect(findCombatant(castCombat, nearEnemy).position, at(5, 2));
  });

  test('ambush vanishes the caster', () {
    final enemy = combatant(at: at(7, 4), faction: Faction.team);
    final caster = combatant(
      at: at(0, 0),
      faction: Faction.enemy,
      stats: statsOf(health: 100),
      character: dummy(
        ability: ability([
          AmbushEffect(seconds: atEveryStar(1), target: const LowestHealthEnemyTarget()),
        ], trigger: const LowHealthTrigger(healthPercentage: 30)),
      ),
    ).createCopyWith(currentHealth: 10, targetCombatantId: enemy.id);

    final castCombat = castAbilityIfReady(combatWith([caster, enemy]), caster.id);
    final vanishedCaster = findCombatant(castCombat, caster);

    expect(vanishedCaster.combatLastingEffects.whereType<VanishedCombatLastingEffect>().single.reappearNextToCombatantId, enemy.id);
    expect(vanishedCaster.isTargetable, isFalse);
    expect(vanishedCaster.canAct, isFalse);
  });

  test('a shield ability protects the target', () {
    final caster = combatant(
      at: at(4, 2),
      faction: Faction.team,
      stats: statsOf(manaStart: 50),
      character: dummy(
        ability: ability([ShieldEffect(value: atEveryStar(200), seconds: atEveryStar(3), target: const SelfTarget())]),
      ),
    );

    final shieldedCaster = findCombatant(castAbilityIfReady(combatWith([caster]), caster.id), caster);
    final shield = shieldedCaster.combatLastingEffects.whereType<ShieldCombatLastingEffect>().single;

    expect(shieldedCaster.currentShield, 200);
    expect(shield.remainingTicks, 30);
    expect(shield.sourceCombatantId, caster.id);
  });

  test('a shielded target ignores a new shield', () {
    final caster = withCombatLastingEffects(
      combatant(
        at: at(4, 2),
        faction: Faction.team,
        stats: statsOf(manaStart: 50),
        character: dummy(
          ability: ability([ShieldEffect(value: atEveryStar(200), seconds: atEveryStar(3), target: const SelfTarget())]),
        ),
      ),
      [const ShieldCombatLastingEffect(onExpire: [], remainingTicks: 10, remainingShield: 50, sourceCombatantId: 99)],
    );

    final shieldedCaster = findCombatant(castAbilityIfReady(combatWith([caster]), caster.id), caster);

    expect(shieldedCaster.currentShield, 50);
  });

  test('a damage over time ability poisons the focus and poisons stack', () {
    final target = withCombatLastingEffects(combatant(at: at(2, 0), faction: Faction.team), [
      const DamageOverTimeCombatLastingEffect(remainingTicks: 10, damagePerSecond: 10, sourceCombatantId: 99),
    ]);
    final caster = combatant(
      at: at(1, 0),
      faction: Faction.enemy,
      stats: statsOf(manaStart: 50),
      character: dummy(
        ability: ability([
          DamageOverTimeEffect(seconds: atEveryStar(4), target: const FocusTarget(), damagePerSecond: atEveryStar(30)),
        ]),
      ),
    ).createCopyWith(targetCombatantId: target.id);

    final castCombat = castAbilityIfReady(combatWith([caster, target]), caster.id);
    final poisons = findCombatant(castCombat, target).combatLastingEffects.whereType<DamageOverTimeCombatLastingEffect>();

    expect(poisons, hasLength(2));
    expect(poisons.last.damagePerSecond, 30);
    expect(poisons.last.remainingTicks, 40);
    expect(poisons.last.sourceCombatantId, caster.id);
  });

  test('a heal over time ability heals the target and does not stack', () {
    final alreadyHealingAlly = withCombatLastingEffects(combatant(at: at(6, 1), faction: Faction.team), [
      const HealOverTimeCombatLastingEffect(healPerSecond: 5, remainingTicks: 10, sourceCombatantId: 99),
    ]);
    final caster = combatant(
      at: at(6, 2),
      faction: Faction.team,
      stats: statsOf(manaStart: 50),
      character: dummy(
        ability: ability([
          HealOverTimeEffect(seconds: atEveryStar(2), healPerSecond: atEveryStar(20), target: const NearbyAlliesTarget()),
        ]),
      ),
    );

    final castCombat = castAbilityIfReady(combatWith([caster, alreadyHealingAlly]), caster.id);
    final casterHeals = findCombatant(castCombat, caster).combatLastingEffects.whereType<HealOverTimeCombatLastingEffect>();
    final allyHeals = findCombatant(castCombat, alreadyHealingAlly).combatLastingEffects.whereType<HealOverTimeCombatLastingEffect>();

    expect(casterHeals.single.healPerSecond, 20);
    expect(casterHeals.single.remainingTicks, 20);
    expect(allyHeals.single.healPerSecond, 5);
  });

  test('a debuff ability lowers the focus stat', () {
    final target = combatant(at: at(0, 0), faction: Faction.enemy, stats: statsOf(armor: 100));
    final caster = combatant(
      at: at(1, 0),
      faction: Faction.team,
      stats: statsOf(manaStart: 50),
      character: dummy(
        ability: ability([
          StatModifierEffect(
            stat: Stat.armor,
            value: atEveryStar(0.5),
            seconds: atEveryStar(2),
            target: const FocusTarget(),
            changeType: StatChangeType.multiplier,
          ),
        ]),
      ),
    ).createCopyWith(targetCombatantId: target.id);

    final debuffedTarget = findCombatant(castAbilityIfReady(combatWith([caster, target]), caster.id), target);

    expect(debuffedTarget.getCurrentStat(Stat.armor), 50);
    expect(debuffedTarget.combatLastingEffects.whereType<StatModifierCombatLastingEffect>().single.remainingTicks, 20);
  });
}
