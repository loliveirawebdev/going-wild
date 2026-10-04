part of 'combat_history_cause.dart';

class ScheduledEffectsHistoryCause extends CombatHistoryCause {
  const ScheduledEffectsHistoryCause({required this.sourceCombatantId});
  const ScheduledEffectsHistoryCause.ofActor({required int actorCombatantId}) : sourceCombatantId = actorCombatantId;
  final int sourceCombatantId;

  @override
  String toString() => 'scheduled effects of #$sourceCombatantId';
}
