import 'package:going_wild/domain/models/combat/combat.dart';
import 'package:going_wild/domain/models/combat/combat_in_progress.dart';
import 'package:going_wild/domain/models/combat_history/combat_history.dart';
import 'package:going_wild/domain/models/combat_history/combat_history_step.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';
import 'package:meta/meta.dart';

class CombatWithHistory extends CombatInProgress {
  const CombatWithHistory({required super.combat, required this.history});

  CombatWithHistory.started(Combat combat)
    : this(
        combat: combat,
        history: CombatHistory(entries: const []).createCopyWithCombatStarted(
          tick: combat.elapsedTicks,
          combatants: combat.battlefield.combatants,
        ),
      );

  @override
  final CombatHistory history;

  @override
  @useResult
  CombatWithHistory createCopyWithCombat(Combat combat) => CombatWithHistory(combat: combat, history: history);

  @override
  @useResult
  CombatWithHistory createCopyAfterStep({required CombatHistoryStep step, required Combat Function(Combat combat) action}) {
    final combatAfterStep = action(combat);

    final historyAfterStep = history.createCopyWithStepCompared(
      step: step,
      tick: combat.elapsedTicks,
      combatantsBefore: combat.battlefield.combatants,
      combatantsAfter: combatAfterStep.battlefield.combatants,
    );

    return CombatWithHistory(combat: combatAfterStep, history: historyAfterStep);
  }

  @override
  @useResult
  CombatHistory createHistoryEndedWith({required Faction? winningFaction}) =>
      history.createCopyWithCombatEnded(tick: combat.elapsedTicks, winningFaction: winningFaction);
}
