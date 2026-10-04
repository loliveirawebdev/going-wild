part of 'combat_history_cause.dart';

class AbilityHistoryCause extends CombatHistoryCause {
  const AbilityHistoryCause({required this.casterCombatantId});
  const AbilityHistoryCause.ofActor({required int actorCombatantId}) : casterCombatantId = actorCombatantId;
  final int casterCombatantId;

  @override
  String toString() => 'ability of #$casterCombatantId';
}
