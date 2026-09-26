import 'combat_history_step_kind.dart';

class CombatHistoryStep {
  const CombatHistoryStep({required this.kind, required this.actorCombatantId});
  final CombatHistoryStepKind kind;
  final int actorCombatantId;
}
