part of 'combat_history_entry.dart';

class CombatEndedHistoryEntry extends CombatHistoryEntry {
  const CombatEndedHistoryEntry({required super.tick, required this.winningFaction});
  final Faction? winningFaction;
}
