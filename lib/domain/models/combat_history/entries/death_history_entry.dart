part of 'combat_history_entry.dart';

class DeathHistoryEntry extends CombatHistoryEntry {
  const DeathHistoryEntry({required super.tick, required this.combatantId, required this.killerCombatantId});
  final int? killerCombatantId;
  final int combatantId;
}
