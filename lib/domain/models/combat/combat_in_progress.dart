import 'package:going_wild/domain/models/combat/combat.dart';
import 'package:going_wild/domain/models/combat/combat_result.dart';
import 'package:going_wild/domain/models/combat/combat_with_history.dart';
import 'package:going_wild/domain/models/combat/combat_without_history.dart';
import 'package:going_wild/domain/models/combat/combatant_actions/apply_combat_effects.dart';
import 'package:going_wild/domain/models/combat_history/combat_history.dart';
import 'package:going_wild/domain/models/combat_history/combat_history_step.dart';
import 'package:going_wild/domain/models/combat_history/combat_history_step_kind.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';
import 'package:meta/meta.dart';

abstract class CombatInProgress {
  const CombatInProgress({required this.combat});

  factory CombatInProgress.started(Combat combat, {required bool recordsHistory}) =>
      recordsHistory ? CombatWithHistory.started(combat) : CombatWithoutHistory(combat: combat);

  final Combat combat;

  CombatHistory get history;

  Combatant combatantWithId(int combatantId) => combat.battlefield.combatantWithId(combatantId);

  @useResult
  CombatInProgress createCopyWithCombat(Combat combat);

  @useResult
  CombatInProgress createCopyAfterStep({required CombatHistoryStep step, required Combat Function(Combat combat) action});

  @useResult
  CombatHistory createHistoryEndedWith({required Faction? winningFaction});

  @useResult
  CombatInProgress createCopyAfterPendingEffects() {
    final pendingApplications = combat.pendingCombatEffectApplications;
    if (pendingApplications.isEmpty) return this;

    final nextPendingApplication = pendingApplications.first;
    final sourceCombatantId = nextPendingApplication.sourceCombatantId;
    final combatWithoutNextPending = combat.createCopyWith(pendingCombatEffectApplications: pendingApplications.skip(1).toList());
    final withoutNextPending = createCopyWithCombat(combatWithoutNextPending);

    final afterNextPending = nextPendingApplication.effects.isEmpty
        ? withoutNextPending
        : withoutNextPending.createCopyAfterStep(
            step: CombatHistoryStep(actorCombatantId: sourceCombatantId, kind: CombatHistoryStepKind.applyPendingCombatEffects),
            action: (combat) => applyCombatEffects(combat, sourceCombatantId: sourceCombatantId, effects: nextPendingApplication.effects),
          );

    return afterNextPending.createCopyAfterPendingEffects();
  }

  @useResult
  CombatInProgress createCopyWithNextTick() => createCopyWithCombat(combat.createCopyWith(elapsedTicks: combat.elapsedTicks + 1));

  CombatResult createCombatResult({required Faction? winningFaction}) => CombatResult(
    winningFaction: winningFaction,
    elapsedSeconds: combat.elapsedSeconds,
    combatants: combat.battlefield.combatants,
    history: createHistoryEndedWith(winningFaction: winningFaction),
  );
}
