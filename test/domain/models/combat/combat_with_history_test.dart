import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/models/character/stars/star_values.dart';
import 'package:going_wild/domain/models/combat/combat_with_history.dart';
import 'package:going_wild/domain/models/combat/combatant_actions/attack_target.dart';
import 'package:going_wild/domain/models/combat/pending_combat_effect_application.dart';
import 'package:going_wild/domain/models/combat_history/causes/combat_history_cause.dart';
import 'package:going_wild/domain/models/combat_history/combat_history_step.dart';
import 'package:going_wild/domain/models/combat_history/combat_history_step_kind.dart';
import 'package:going_wild/domain/models/combat_history/entries/combat_history_entry.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/damage/damage_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/targets/nearby_enemies_target.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';

import '../../../helpers/combat_helpers.dart';

void main() {
  test('starting records the combat start and keeps the combat untouched', () {
    final combat = combatWith([combatant(at: at(7, 2), faction: Faction.team)]);

    final combatWithHistory = CombatWithHistory.started(combat);

    expect(combatWithHistory.combat, same(combat));
    expect(combatWithHistory.history.entries.single, isA<CombatStartedHistoryEntry>());
  });

  test('a step runs the action and records what changed, leaving the original untouched', () {
    final enemy = combatant(at: at(0, 0), faction: Faction.enemy);
    final attacker = combatant(at: at(1, 0), faction: Faction.team).createCopyWith(targetCombatantId: enemy.id);
    final combatWithHistory = CombatWithHistory.started(combatWith([attacker, enemy]));

    final afterAttack = combatWithHistory.createCopyAfterStep(
      action: (combat) => attackTarget(combat, attacker.id),
      step: CombatHistoryStep(actorCombatantId: attacker.id, kind: CombatHistoryStepKind.attackTarget),
    );

    expect(afterAttack.combatantWithId(enemy.id).currentHealth, 900);
    expect(combatWithHistory.combatantWithId(enemy.id).currentHealth, 1000);
    expect(afterAttack.history.entries.whereType<AttackLandedHistoryEntry>().single.targetCombatantId, enemy.id);
    expect(combatWithHistory.history.entries.whereType<AttackLandedHistoryEntry>(), isEmpty);
  });

  test('pending effects are applied in order, recorded as scheduled effects and cleared', () {
    final source = combatant(at: at(6, 2), faction: Faction.team);
    final enemy = combatant(at: at(5, 2), faction: Faction.enemy);
    const explosion = [DamageEffect(target: NearbyEnemiesTarget(), value: StarValues(star1: 100, star2: 100, star3: 100))];

    final combat = combatWith([source, enemy]).createCopyWith(
      pendingCombatEffectApplications: [
        PendingCombatEffectApplication(effects: explosion, sourceCombatantId: source.id),
        PendingCombatEffectApplication(effects: const [], sourceCombatantId: source.id),
        PendingCombatEffectApplication(effects: explosion, sourceCombatantId: source.id),
      ],
    );

    final afterPendingEffects = CombatWithHistory.started(combat).createCopyAfterPendingEffects();
    final damageEntries = afterPendingEffects.history.entries.whereType<DamageTakenHistoryEntry>().toList();

    expect(afterPendingEffects.combat.pendingCombatEffectApplications, isEmpty);
    expect(afterPendingEffects.combatantWithId(enemy.id).currentHealth, 800);
    expect(damageEntries.map((entry) => entry.currentHealth), [900, 800]);
    expect(damageEntries.map((entry) => entry.cause), everyElement(isA<ScheduledEffectsHistoryCause>()));
  });

  test('without pending effects nothing changes', () {
    final combatWithHistory = CombatWithHistory.started(combatWith([combatant(at: at(7, 2), faction: Faction.team)]));

    expect(combatWithHistory.createCopyAfterPendingEffects(), same(combatWithHistory));
  });

  test('the next tick only advances the clock', () {
    final combatWithHistory = CombatWithHistory.started(combatWith([combatant(at: at(7, 2), faction: Faction.team)]));

    final atNextTick = combatWithHistory.createCopyWithNextTick();

    expect(atNextTick.combat.elapsedTicks, combatWithHistory.combat.elapsedTicks + 1);
    expect(atNextTick.history, same(combatWithHistory.history));
  });

  test('the result carries the final combatants and closes the history', () {
    final combatWithHistory = CombatWithHistory.started(combatWith([combatant(at: at(7, 2), faction: Faction.team)]))
        .createCopyWithNextTick();

    final result = combatWithHistory.createCombatResult(winningFaction: Faction.team);

    expect(result.winningFaction, Faction.team);
    expect(result.combatants, combatWithHistory.combat.battlefield.combatants);
    expect(result.elapsedSeconds, combatWithHistory.combat.elapsedSeconds);
    expect((result.history.entries.last as CombatEndedHistoryEntry).tick, 1);
  });
}
