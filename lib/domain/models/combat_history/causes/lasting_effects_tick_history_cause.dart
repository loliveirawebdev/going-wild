part of 'combat_history_cause.dart';

class LastingEffectsTickHistoryCause extends CombatHistoryCause {
  const LastingEffectsTickHistoryCause({required this.ownerCombatantId});
  const LastingEffectsTickHistoryCause.ofActor({required int actorCombatantId}) : ownerCombatantId = actorCombatantId;
  final int ownerCombatantId;

  @override
  String toString() => 'lasting effects tick of #$ownerCombatantId';
}
