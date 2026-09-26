import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/models/character/stars/star_values.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stat_change_type.dart';
import 'package:going_wild/domain/models/character/stats/stat_modification.dart';
import 'package:going_wild/domain/models/combat/combat.dart';
import 'package:going_wild/domain/models/combat/combatant_actions/advance_combat_lasting_effects_by_one_tick.dart';
import 'package:going_wild/domain/models/combat/combatant_actions/apply_combat_effects.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/combat_effect_target.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/ambush/vanished_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/damage/damage_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/damage_over_time/damage_over_time_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/damage_over_time/damage_over_time_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/heal_over_time/heal_over_time_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/shield/shield_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stat_modifier/stat_modifier_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/taunt/taunt_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';

import '../../../helpers/combat_helpers.dart';

Combat advanceTicks(Combat combat, Combatant combatant, int tickCount) {
  var advancedCombat = combat;
  for (var tick = 0; tick < tickCount; tick++) advancedCombat = advanceCombatLastingEffectsByOneTick(advancedCombat, combatant.id);
  return advancedCombat;
}

void main() {
  const explosion = [DamageEffect(target: CombatEffectTarget.nearbyEnemies, value: StarValues(star1: 100, star2: 100, star3: 100))];

  test('damage over time hurts on every tick until its duration ends', () {
    final poisonedCombatant = withCombatLastingEffects(combatant(at: at(7, 4), faction: Faction.team), [
      const DamageOverTimeCombatLastingEffect(remainingTicks: 10, damagePerSecond: 30, sourceCombatantId: 99),
    ]);

    final halfwayCombat = advanceTicks(combatWith([poisonedCombatant]), poisonedCombatant, 5);
    expect(findCombatant(halfwayCombat, poisonedCombatant).currentHealth, closeTo(1000 - 15, 0.001));

    final finishedCombat = advanceTicks(halfwayCombat, poisonedCombatant, 10);
    expect(findCombatant(finishedCombat, poisonedCombatant).currentHealth, closeTo(1000 - 30, 0.001));
    expect(findCombatant(finishedCombat, poisonedCombatant).combatLastingEffects, isEmpty);
  });

  test('an effect of N seconds applies its tick consequence N times ticks per second, including the tick it expires on', () {
    const damagePerSecond = 10.0;

    for (final seconds in [0.5, 1, 1.5, 2, 2.5, 5, 8]) {
      final expectedTickCount = (seconds * testRules.ticksPerSecond).round();
      final expectedDamage = expectedTickCount * damagePerSecond / testRules.ticksPerSecond;
      final poisonedCombatant = combatant(at: at(7, 4), faction: Faction.team, stats: statsOf(health: 10000));
      final poisonedCombat = applyCombatEffects(
        combatWith([poisonedCombatant]),
        sourceCombatantId: poisonedCombatant.id,
        effects: [
          DamageOverTimeEffect(
            target: CombatEffectTarget.self,
            seconds: atEveryStar(seconds.toDouble()),
            damagePerSecond: atEveryStar(damagePerSecond),
          ),
        ],
      );

      final lastTickCombat = advanceTicks(poisonedCombat, poisonedCombatant, expectedTickCount);
      final afterExpirationCombat = advanceTicks(lastTickCombat, poisonedCombatant, 5);

      expect(findCombatant(lastTickCombat, poisonedCombatant).combatLastingEffects, isEmpty, reason: '$seconds s');
      expect(findCombatant(lastTickCombat, poisonedCombatant).currentHealth, closeTo(10000 - expectedDamage, 0.001), reason: '$seconds s');
      expect(
        findCombatant(afterExpirationCombat, poisonedCombatant).currentHealth,
        findCombatant(lastTickCombat, poisonedCombatant).currentHealth,
        reason: '$seconds s',
      );
    }
  });

  test('heal over time heals on every tick and never above max health', () {
    final healedCombatant = withCombatLastingEffects(combatant(at: at(7, 4), faction: Faction.team).createCopyWith(currentHealth: 990), [
      const HealOverTimeCombatLastingEffect(healPerSecond: 50, remainingTicks: 10, sourceCombatantId: 99),
    ]);

    final firstTickCombat = advanceTicks(combatWith([healedCombatant]), healedCombatant, 1);
    final finishedCombat = advanceTicks(firstTickCombat, healedCombatant, 10);

    expect(findCombatant(firstTickCombat, healedCombatant).currentHealth, closeTo(995, 0.001));
    expect(findCombatant(finishedCombat, healedCombatant).currentHealth, 1000);
    expect(findCombatant(finishedCombat, healedCombatant).combatLastingEffects, isEmpty);
  });

  test('a lethal tick stops the remaining lasting effects of that tick', () {
    final poisonedCombatant = withCombatLastingEffects(combatant(at: at(7, 4), faction: Faction.team).createCopyWith(currentHealth: 1), [
      const DamageOverTimeCombatLastingEffect(remainingTicks: 50, damagePerSecond: 100, sourceCombatantId: 99),
      const HealOverTimeCombatLastingEffect(healPerSecond: 100, remainingTicks: 50, sourceCombatantId: 99),
    ]);

    final tickedCombat = advanceTicks(combatWith([poisonedCombatant]), poisonedCombatant, 1);

    expect(findCombatant(tickedCombat, poisonedCombatant).isAlive, isFalse);
  });

  test('a shield that times out is removed and schedules its on expire effects', () {
    final shieldedCombatant = withCombatLastingEffects(combatant(at: at(6, 2), faction: Faction.team), [
      const ShieldCombatLastingEffect(remainingTicks: 1, onExpire: explosion, remainingShield: 100, sourceCombatantId: 99),
    ]);

    final tickedCombat = advanceTicks(combatWith([shieldedCombatant]), shieldedCombatant, 1);

    expect(findCombatant(tickedCombat, shieldedCombatant).currentShield, 0);
    expect(tickedCombat.pendingCombatEffectApplications.single.sourceCombatantId, 99);
    expect(tickedCombat.pendingCombatEffectApplications.single.effects, explosion);
  });

  test('a stat modifier wears off after its duration', () {
    const halfArmor = StatModification(value: 0.5, stat: Stat.armor, changeType: StatChangeType.multiplier);
    final debuffedCombatant = withCombatLastingEffects(combatant(at: at(7, 4), faction: Faction.team, stats: statsOf(armor: 100)), [
      const StatModifierCombatLastingEffect(remainingTicks: 2, sourceCombatantId: 99, statModification: halfArmor),
    ]);

    final firstTickCombat = advanceTicks(combatWith([debuffedCombatant]), debuffedCombatant, 1);
    final secondTickCombat = advanceTicks(firstTickCombat, debuffedCombatant, 1);

    expect(findCombatant(firstTickCombat, debuffedCombatant).getCurrentStat(Stat.armor), 50);
    expect(findCombatant(secondTickCombat, debuffedCombatant).getCurrentStat(Stat.armor), 100);
  });

  test('taunt ends early when the taunter can no longer be targeted', () {
    final deadTaunter = combatant(at: at(0, 0), faction: Faction.enemy).createCopyWith(currentHealth: 0);
    final tauntedCombatant = withCombatLastingEffects(combatant(at: at(7, 4), faction: Faction.team), [
      TauntCombatLastingEffect(remainingTicks: 50, sourceCombatantId: deadTaunter.id),
    ]);

    final tickedCombat = advanceTicks(combatWith([tauntedCombatant, deadTaunter]), tauntedCombatant, 1);

    expect(findCombatant(tickedCombat, tauntedCombatant).combatLastingEffects, isEmpty);
  });

  test('a vanished combatant reappears next to its anchor and targets it', () {
    final anchorEnemy = combatant(at: at(7, 4), faction: Faction.team);
    final vanishedCombatant = withCombatLastingEffects(combatant(at: at(0, 0), faction: Faction.enemy), [
      VanishedCombatLastingEffect(remainingTicks: 1, sourceCombatantId: 99, reappearNextToCombatantId: anchorEnemy.id),
    ]);

    final tickedCombat = advanceTicks(combatWith([vanishedCombatant, anchorEnemy]), vanishedCombatant, 1);
    final reappearedCombatant = findCombatant(tickedCombat, vanishedCombatant);

    expect(reappearedCombatant.position.distanceToPosition(anchorEnemy.position), 1);
    expect(reappearedCombatant.targetCombatantId, anchorEnemy.id);
    expect(reappearedCombatant.isTargetable, isTrue);
  });
}
