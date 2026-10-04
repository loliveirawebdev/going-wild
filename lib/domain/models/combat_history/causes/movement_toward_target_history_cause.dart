part of 'combat_history_cause.dart';

class MovementTowardTargetHistoryCause extends CombatHistoryCause {
  const MovementTowardTargetHistoryCause({required this.movingCombatantId});
  const MovementTowardTargetHistoryCause.ofActor({required int actorCombatantId}) : movingCombatantId = actorCombatantId;
  final int movingCombatantId;

  @override
  String toString() => 'movement of #$movingCombatantId';
}
