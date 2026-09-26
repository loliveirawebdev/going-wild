part of 'combat_history_entry.dart';

class ManaReceivedHistoryEntry extends CombatHistoryEntry {
  const ManaReceivedHistoryEntry({required super.tick, required this.amount, required this.combatantId, required this.currentMana});

  final double amount;
  final int combatantId;
  final double currentMana;
}
