import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/models/combat/combat.dart';
import 'package:going_wild/domain/models/combat/combatant_actions/acquire_target.dart';
import 'package:going_wild/domain/models/combat/combatant_actions/advance_combat_lasting_effects_by_one_tick.dart';
import 'package:going_wild/domain/models/combat/combatant_actions/attack_target.dart';
import 'package:going_wild/domain/models/combat/combatant_actions/cast_ability_if_ready.dart';
import 'package:going_wild/domain/models/combat/combatant_actions/move_toward_target.dart';
import 'package:going_wild/domain/models/combat_history/causes/combat_history_cause.dart';
import 'package:going_wild/domain/models/combat_history/combat_history.dart';
import 'package:going_wild/domain/models/combat_history/combat_history_step.dart';
import 'package:going_wild/domain/models/combat_history/combat_history_step_kind.dart';
import 'package:going_wild/domain/models/combat_history/entries/combat_history_entry.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/damage/damage_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/damage_over_time/damage_over_time_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/shield/shield_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/shield/shield_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stun/stun_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stun/stun_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/focus_target.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/self_target.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';

import '../../../helpers/combat_helpers.dart';

final emptyHistory = CombatHistory(entries: const []);

List<CombatHistoryEntry> entriesOfStep(Combat combat, CombatHistoryStepKind kind, Combatant actor, Combat Function(Combat combat) action) {
  final combatAfterStep = action(combat);

  final history = emptyHistory.createCopyWithStepCompared(
    tick: combat.elapsedTicks,
    combatantsBefore: combat.battlefield.combatants,
    combatantsAfter: combatAfterStep.battlefield.combatants,
    step: CombatHistoryStep(kind: kind, actorCombatantId: actor.id),
  );

  return history.entries;
}

void main() {
  group('the history itself', () {
    test('a new history keeps its entries and cannot be changed from outside', () {
      final history = CombatHistory(entries: const [CombatStartedHistoryEntry(tick: 0, combatants: [])]);

      expect(history.entries.single, isA<CombatStartedHistoryEntry>());
      expect(() => history.entries.add(const CombatStartedHistoryEntry(tick: 1, combatants: [])), throwsUnsupportedError);
    });

    test('adding entries creates a new history and keeps the original untouched', () {
      final startedHistory = emptyHistory.createCopyWithCombatStarted(tick: 0, combatants: const []);
      final endedHistory = startedHistory.createCopyWithCombatEnded(tick: 30, winningFaction: Faction.team);

      expect(emptyHistory.entries, isEmpty);
      expect(startedHistory.entries.single, isA<CombatStartedHistoryEntry>());
      expect(endedHistory.entries.map((entry) => entry.runtimeType), [CombatStartedHistoryEntry, CombatEndedHistoryEntry]);
      expect((endedHistory.entries.last as CombatEndedHistoryEntry).winningFaction, Faction.team);
    });

    test('every step kind creates the cause of its actor', () {
      const actorCombatantId = 7;

      int actorCombatantIdOf(CombatHistoryCause cause) => switch (cause) {
        CombatStartHistoryCause() => -1,
        AbilityHistoryCause() => cause.casterCombatantId,
        BasicAttackHistoryCause() => cause.attackerCombatantId,
        MovementTowardTargetHistoryCause() => cause.movingCombatantId,
        ScheduledEffectsHistoryCause() => cause.sourceCombatantId,
        TargetAcquisitionHistoryCause() => cause.searchingCombatantId,
        LastingEffectsTickHistoryCause() => cause.ownerCombatantId,
      };

      final expectedCauseTypeByKind = {
        CombatHistoryStepKind.castAbility: AbilityHistoryCause,
        CombatHistoryStepKind.attackTarget: BasicAttackHistoryCause,
        CombatHistoryStepKind.acquireTarget: TargetAcquisitionHistoryCause,
        CombatHistoryStepKind.moveTowardTarget: MovementTowardTargetHistoryCause,
        CombatHistoryStepKind.applyPendingCombatEffects: ScheduledEffectsHistoryCause,
        CombatHistoryStepKind.advanceCombatLastingEffects: LastingEffectsTickHistoryCause,
      };

      expect(expectedCauseTypeByKind.keys, unorderedEquals(CombatHistoryStepKind.values));

      for (final kind in CombatHistoryStepKind.values) {
        final cause = CombatHistoryStep(kind: kind, actorCombatantId: actorCombatantId).cause;

        expect(cause.runtimeType, expectedCauseTypeByKind[kind], reason: '$kind');
        expect(actorCombatantIdOf(cause), actorCombatantId, reason: '$kind');
      }
    });

    test('a step that changes nothing returns the same history', () {
      final idleCombatant = combatant(at: at(7, 2), faction: Faction.team);

      final history = emptyHistory.createCopyWithStepCompared(
        tick: 0,
        combatantsAfter: [idleCombatant],
        combatantsBefore: [idleCombatant],
        step: CombatHistoryStep(actorCombatantId: idleCombatant.id, kind: CombatHistoryStepKind.castAbility),
      );

      expect(history, same(emptyHistory));
    });

    test('starting the combat records the lasting effects combatants already have', () {
      final shieldedCombatant = withCombatLastingEffects(combatant(at: at(7, 2), faction: Faction.team), [
        const ShieldCombatLastingEffect(onExpire: [], remainingTicks: 80, remainingShield: 150, sourceCombatantId: 99),
      ]);

      final history = emptyHistory.createCopyWithCombatStarted(tick: 0, combatants: [shieldedCombatant]);
      final startedEffect = history.entries.whereType<LastingEffectStartedHistoryEntry>().single;

      expect(history.entries.first, isA<CombatStartedHistoryEntry>());
      expect(startedEffect.combatantId, shieldedCombatant.id);
      expect(startedEffect.combatLastingEffect, isA<ShieldCombatLastingEffect>());
      expect(startedEffect.cause, isA<CombatStartHistoryCause>());
    });

    test('combatants are matched by id even when the lists come in a different order', () {
      final firstCombatant = combatant(at: at(7, 1), faction: Faction.team);
      final secondCombatant = combatant(at: at(7, 3), faction: Faction.team);
      final movedSecondCombatant = secondCombatant.createCopyWith(position: at(6, 3));

      final history = emptyHistory.createCopyWithStepCompared(
        tick: 0,
        combatantsBefore: [firstCombatant, secondCombatant],
        combatantsAfter: [movedSecondCombatant, firstCombatant],
        step: CombatHistoryStep(actorCombatantId: secondCombatant.id, kind: CombatHistoryStepKind.moveTowardTarget),
      );

      expect(history.entries.single, isA<MovementHistoryEntry>());
      expect((history.entries.single as MovementHistoryEntry).combatantId, secondCombatant.id);
    });
  });

  group('comparing a step', () {
    test('acquiring a target records the new target', () {
      final attacker = combatant(at: at(7, 2), faction: Faction.team);
      final enemy = combatant(at: at(5, 2), faction: Faction.enemy);
      final combat = combatWith([attacker, enemy]);

      final entries = entriesOfStep(combat, CombatHistoryStepKind.acquireTarget, attacker, (combat) => acquireTarget(combat, attacker.id));
      final newTarget = entries.whereType<TargetAcquiredHistoryEntry>().single;

      expect(newTarget.combatantId, attacker.id);
      expect(newTarget.targetCombatantId, enemy.id);
      expect(newTarget.tick, combat.elapsedTicks);
    });

    test('an attack records the hit, the damage by the attacker and the mana gained', () {
      final enemy = combatant(at: at(0, 0), faction: Faction.enemy);
      final attacker = combatant(at: at(1, 0), faction: Faction.team).createCopyWith(targetCombatantId: enemy.id);
      final combat = combatWith([attacker, enemy]);

      final entries = entriesOfStep(combat, CombatHistoryStepKind.attackTarget, attacker, (combat) => attackTarget(combat, attacker.id));
      final damageTaken = entries.whereType<DamageTakenHistoryEntry>().single;

      expect(entries.whereType<AttackLandedHistoryEntry>().single.targetCombatantId, enemy.id);
      expect(damageTaken.amount, 100);
      expect(damageTaken.combatantId, enemy.id);
      expect(damageTaken.currentHealth, 900);
      expect(damageTaken.sourceCombatantId, attacker.id);
      expect((damageTaken.cause as BasicAttackHistoryCause).attackerCombatantId, attacker.id);
      expect(entries.whereType<ManaReceivedHistoryEntry>().single.amount, testRules.manaPerHit);
    });

    test('the entries of whoever acted come first, even when the target comes before in the list', () {
      final target = combatant(at: at(1, 0), faction: Faction.team);
      final attacker = combatant(at: at(0, 0), faction: Faction.enemy).createCopyWith(targetCombatantId: target.id);
      final combat = combatWith([target, attacker]);

      final entries = entriesOfStep(combat, CombatHistoryStepKind.attackTarget, attacker, (combat) => attackTarget(combat, attacker.id));

      expect(entries.first, isA<AttackLandedHistoryEntry>());
      expect(entries.whereType<DamageTakenHistoryEntry>().single.combatantId, target.id);
    });

    test('an attack still waiting for its timer records nothing', () {
      final enemy = combatant(at: at(0, 0), faction: Faction.enemy);
      final attacker = combatant(at: at(1, 0), faction: Faction.team).createCopyWith(ticksUntilNextAttack: 5, targetCombatantId: enemy.id);
      final combat = combatWith([attacker, enemy]);

      final entries = entriesOfStep(combat, CombatHistoryStepKind.attackTarget, attacker, (combat) => attackTarget(combat, attacker.id));

      expect(entries, isEmpty);
    });

    test('two attackers on the same target in the same tick record their own damage', () {
      final enemy = combatant(at: at(0, 1), faction: Faction.enemy);
      final firstAttacker = combatant(
        at: at(1, 1),
        faction: Faction.team,
        stats: statsOf(damage: 100),
      ).createCopyWith(targetCombatantId: enemy.id);
      final secondAttacker = combatant(
        at: at(1, 2),
        faction: Faction.team,
        stats: statsOf(damage: 80),
      ).createCopyWith(targetCombatantId: enemy.id);
      final combat = combatWith([firstAttacker, secondAttacker, enemy]);
      final combatAfterFirstAttack = attackTarget(combat, firstAttacker.id);

      final firstAttackEntries = entriesOfStep(
        combat,
        CombatHistoryStepKind.attackTarget,
        firstAttacker,
        (combat) => attackTarget(combat, firstAttacker.id),
      );
      final secondAttackEntries = entriesOfStep(
        combatAfterFirstAttack,
        CombatHistoryStepKind.attackTarget,
        secondAttacker,
        (combat) => attackTarget(combat, secondAttacker.id),
      );
      final firstDamage = firstAttackEntries.whereType<DamageTakenHistoryEntry>().single;
      final secondDamage = secondAttackEntries.whereType<DamageTakenHistoryEntry>().single;

      expect((firstDamage.amount, firstDamage.sourceCombatantId), (100, firstAttacker.id));
      expect((secondDamage.amount, secondDamage.sourceCombatantId), (80, secondAttacker.id));
    });

    test('damage absorbed by a shield is part of the damage and the broken shield ends', () {
      final shieldedEnemy = withCombatLastingEffects(combatant(at: at(0, 0), faction: Faction.enemy), [
        const ShieldCombatLastingEffect(onExpire: [], remainingTicks: 50, remainingShield: 60, sourceCombatantId: 99),
      ]);
      final attacker = combatant(at: at(1, 0), faction: Faction.team).createCopyWith(targetCombatantId: shieldedEnemy.id);
      final combat = combatWith([attacker, shieldedEnemy]);

      final entries = entriesOfStep(combat, CombatHistoryStepKind.attackTarget, attacker, (combat) => attackTarget(combat, attacker.id));
      final damageTaken = entries.whereType<DamageTakenHistoryEntry>().single;

      expect(damageTaken.amount, 100);
      expect(damageTaken.absorbedByShield, 60);
      expect(damageTaken.currentHealth, 960);
      expect(entries.whereType<LastingEffectEndedHistoryEntry>().single.combatLastingEffect, isA<ShieldCombatLastingEffect>());
    });

    test('a shield that absorbs part of a hit records its new remaining value', () {
      final shieldedEnemy = withCombatLastingEffects(combatant(at: at(0, 0), faction: Faction.enemy), [
        const ShieldCombatLastingEffect(onExpire: [], remainingTicks: 50, remainingShield: 150, sourceCombatantId: 99),
      ]);
      final attacker = combatant(at: at(1, 0), faction: Faction.team).createCopyWith(targetCombatantId: shieldedEnemy.id);
      final combat = combatWith([attacker, shieldedEnemy]);

      final entries = entriesOfStep(combat, CombatHistoryStepKind.attackTarget, attacker, (combat) => attackTarget(combat, attacker.id));
      final shieldChanged = entries.whereType<LastingEffectChangedHistoryEntry>().single;

      expect(shieldChanged.combatantId, shieldedEnemy.id);
      expect(shieldChanged.cause, isA<BasicAttackHistoryCause>());
      expect(shieldChanged.combatLastingEffectBefore.absorbableDamage, 150);
      expect(shieldChanged.combatLastingEffectAfter.absorbableDamage, 50);
      expect(entries.whereType<LastingEffectEndedHistoryEntry>(), isEmpty);
    });

    test('a lethal hit records the death with the killer', () {
      final enemy = combatant(at: at(0, 0), faction: Faction.enemy, stats: statsOf(health: 50));
      final attacker = combatant(at: at(1, 0), faction: Faction.team).createCopyWith(targetCombatantId: enemy.id);
      final combat = combatWith([attacker, enemy]);

      final entries = entriesOfStep(combat, CombatHistoryStepKind.attackTarget, attacker, (combat) => attackTarget(combat, attacker.id));
      final death = entries.whereType<DeathHistoryEntry>().single;

      expect(death.combatantId, enemy.id);
      expect(death.killerCombatantId, attacker.id);
      expect(death.cause, isA<BasicAttackHistoryCause>());
      expect(entries.whereType<DamageTakenHistoryEntry>().single.amount, 50);
    });

    test('moving records the step from one position to the next', () {
      final enemy = combatant(at: at(0, 2), faction: Faction.enemy);
      final walker = combatant(at: at(7, 2), faction: Faction.team).createCopyWith(targetCombatantId: enemy.id);
      final combat = combatWith([walker, enemy]);

      final entries = entriesOfStep(
        combat,
        CombatHistoryStepKind.moveTowardTarget,
        walker,
        (combat) => moveTowardTarget(combat, walker.id),
      );
      final movement = entries.whereType<MovementHistoryEntry>().single;

      expect(movement.toPosition, at(6, 2));
      expect(movement.fromPosition, at(7, 2));
      expect(movement.sourceCombatantId, walker.id);
      expect((movement.cause as MovementTowardTargetHistoryCause).movingCombatantId, walker.id);
    });

    test('casting records the ability, its damage and the lasting effects it starts', () {
      final enemy = combatant(at: at(0, 0), faction: Faction.enemy);
      final caster = combatant(
        at: at(1, 0),
        faction: Faction.team,
        stats: statsOf(manaStart: 50),
        character: dummy(
          ability: ability([
            DamageEffect(value: atEveryStar(300), target: const FocusTarget()),
            StunEffect(seconds: atEveryStar(1), target: const FocusTarget()),
          ]),
        ),
      ).createCopyWith(targetCombatantId: enemy.id);
      final combat = combatWith([caster, enemy]);

      final entries = entriesOfStep(combat, CombatHistoryStepKind.castAbility, caster, (combat) => castAbilityIfReady(combat, caster.id));
      final abilityCast = entries.whereType<AbilityCastHistoryEntry>().single;
      final stunStarted = entries.whereType<LastingEffectStartedHistoryEntry>().single;

      expect(entries.first, same(abilityCast));
      expect(abilityCast.combatantId, caster.id);
      expect(abilityCast.affectedCombatantIds, [enemy.id]);
      expect(entries.whereType<ManaSpentHistoryEntry>().single.combatantId, caster.id);
      expect(entries.whereType<ManaSpentHistoryEntry>().single.currentMana, 0);
      expect(entries.whereType<DamageTakenHistoryEntry>().single.amount, 300);
      expect(stunStarted.combatantId, enemy.id);
      expect(stunStarted.combatLastingEffect, isA<StunCombatLastingEffect>());
      expect(stunStarted.combatLastingEffect.sourceCombatantId, caster.id);

      for (final consequence in entries.whereType<CombatConsequenceHistoryEntry>()) {
        expect((consequence.cause as AbilityHistoryCause).casterCombatantId, caster.id, reason: '$consequence');
      }
    });

    test('an ability on the caster itself lists the caster as affected', () {
      final caster = combatant(
        at: at(7, 0),
        faction: Faction.team,
        stats: statsOf(manaStart: 50),
        character: dummy(
          ability: ability([
            ShieldEffect(value: atEveryStar(100), seconds: atEveryStar(2), target: const SelfTarget()),
          ]),
        ),
      );
      final combat = combatWith([caster]);

      final entries = entriesOfStep(combat, CombatHistoryStepKind.castAbility, caster, (combat) => castAbilityIfReady(combat, caster.id));

      expect(entries.whereType<AbilityCastHistoryEntry>().single.affectedCombatantIds, [caster.id]);
      expect(entries.whereType<LastingEffectStartedHistoryEntry>().single.combatLastingEffect, isA<ShieldCombatLastingEffect>());
    });

    test('a lasting effect tick records damage from the poisoner and the poison ending', () {
      final poisonedCombatant = withCombatLastingEffects(combatant(at: at(7, 4), faction: Faction.team), [
        const DamageOverTimeCombatLastingEffect(remainingTicks: 1, damagePerSecond: 30, sourceCombatantId: 99),
      ]);
      final combat = combatWith([poisonedCombatant]);

      final entries = entriesOfStep(
        combat,
        CombatHistoryStepKind.advanceCombatLastingEffects,
        poisonedCombatant,
        (combat) => advanceCombatLastingEffectsByOneTick(combat, poisonedCombatant.id),
      );
      final damageTaken = entries.whereType<DamageTakenHistoryEntry>().single;

      expect(damageTaken.amount, closeTo(3, 0.001));
      expect(damageTaken.sourceCombatantId, 99);
      expect((damageTaken.cause as LastingEffectsTickHistoryCause).ownerCombatantId, poisonedCombatant.id);
      expect(entries.whereType<LastingEffectEndedHistoryEntry>().single.combatLastingEffect, isA<DamageOverTimeCombatLastingEffect>());
    });

    test('time passing records each lasting effect with less time left', () {
      final poisonedCombatant = withCombatLastingEffects(combatant(at: at(7, 4), faction: Faction.team), [
        const DamageOverTimeCombatLastingEffect(remainingTicks: 10, damagePerSecond: 30, sourceCombatantId: 99),
      ]);
      final combat = combatWith([poisonedCombatant]);

      final entries = entriesOfStep(
        combat,
        CombatHistoryStepKind.advanceCombatLastingEffects,
        poisonedCombatant,
        (combat) => advanceCombatLastingEffectsByOneTick(combat, poisonedCombatant.id),
      );
      final poisonChanged = entries.whereType<LastingEffectChangedHistoryEntry>().single;

      expect((poisonChanged.combatLastingEffectBefore as DamageOverTimeCombatLastingEffect).remainingTicks, 10);
      expect((poisonChanged.combatLastingEffectAfter as DamageOverTimeCombatLastingEffect).remainingTicks, 9);
      expect(poisonChanged.cause, isA<LastingEffectsTickHistoryCause>());
    });

    test('poisons from two sources ticking together record one damage without a single source', () {
      final poisonedCombatant = withCombatLastingEffects(combatant(at: at(7, 4), faction: Faction.team), [
        const DamageOverTimeCombatLastingEffect(remainingTicks: 10, damagePerSecond: 30, sourceCombatantId: 98),
        const DamageOverTimeCombatLastingEffect(remainingTicks: 10, damagePerSecond: 10, sourceCombatantId: 99),
      ]);
      final combat = combatWith([poisonedCombatant]);

      final entries = entriesOfStep(
        combat,
        CombatHistoryStepKind.advanceCombatLastingEffects,
        poisonedCombatant,
        (combat) => advanceCombatLastingEffectsByOneTick(combat, poisonedCombatant.id),
      );
      final damageTaken = entries.whereType<DamageTakenHistoryEntry>().single;

      expect(damageTaken.amount, closeTo(4, 0.001));
      expect(damageTaken.sourceCombatantId, isNull);
      expect(entries.whereType<LastingEffectEndedHistoryEntry>(), isEmpty);
    });

    test('a shield expiring by time ends without counting as absorbed damage', () {
      final shieldedCombatant = withCombatLastingEffects(combatant(at: at(7, 4), faction: Faction.team), [
        const ShieldCombatLastingEffect(onExpire: [], remainingTicks: 1, remainingShield: 100, sourceCombatantId: 99),
      ]);
      final combat = combatWith([shieldedCombatant]);

      final entries = entriesOfStep(
        combat,
        CombatHistoryStepKind.advanceCombatLastingEffects,
        shieldedCombatant,
        (combat) => advanceCombatLastingEffectsByOneTick(combat, shieldedCombatant.id),
      );

      expect(entries.whereType<DamageTakenHistoryEntry>(), isEmpty);
      expect(entries.whereType<LastingEffectEndedHistoryEntry>().single.combatLastingEffect, isA<ShieldCombatLastingEffect>());
    });
  });
}
