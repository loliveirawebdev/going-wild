import 'package:going_wild/domain/models/combat_history/causes/combat_history_cause.dart';
import 'package:going_wild/domain/models/combat_history/combat_history_step_kind.dart';

class CombatHistoryStep {
  const CombatHistoryStep({required this.kind, required this.actorCombatantId});
  final CombatHistoryStepKind kind;
  final int actorCombatantId;

  CombatHistoryCause get cause => kind.causeOf(actorCombatantId: actorCombatantId);
}
