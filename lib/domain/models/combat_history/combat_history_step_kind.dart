import 'package:going_wild/domain/models/combat_history/causes/combat_history_cause.dart';

enum CombatHistoryStepKind {
  castAbility(causeOf: AbilityHistoryCause.ofActor),
  attackTarget(causeOf: BasicAttackHistoryCause.ofActor),
  acquireTarget(causeOf: TargetAcquisitionHistoryCause.ofActor),
  moveTowardTarget(causeOf: MovementTowardTargetHistoryCause.ofActor),
  applyPendingCombatEffects(causeOf: ScheduledEffectsHistoryCause.ofActor),
  advanceCombatLastingEffects(causeOf: LastingEffectsTickHistoryCause.ofActor);

  const CombatHistoryStepKind({required this.causeOf});
  final CombatHistoryCause Function({required int actorCombatantId}) causeOf;
}
