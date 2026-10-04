part of 'combat_history_cause.dart';

class BasicAttackHistoryCause extends CombatHistoryCause {
  const BasicAttackHistoryCause({required this.attackerCombatantId});
  const BasicAttackHistoryCause.ofActor({required int actorCombatantId}) : attackerCombatantId = actorCombatantId;
  final int attackerCombatantId;

  @override
  String toString() => 'basic attack of #$attackerCombatantId';
}
