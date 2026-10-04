part of 'combat_history_cause.dart';

class TargetAcquisitionHistoryCause extends CombatHistoryCause {
  const TargetAcquisitionHistoryCause({required this.searchingCombatantId});
  const TargetAcquisitionHistoryCause.ofActor({required int actorCombatantId}) : searchingCombatantId = actorCombatantId;
  final int searchingCombatantId;

  @override
  String toString() => 'target acquisition of #$searchingCombatantId';
}
