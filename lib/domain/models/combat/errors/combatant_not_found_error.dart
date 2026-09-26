class CombatantNotFoundError extends StateError {
  CombatantNotFoundError({required int combatantId}) : super('No combatant with id $combatantId is on the battlefield');
}
