part of 'combat_history_entry.dart';

class CombatStartedHistoryEntry extends CombatHistoryEntry {
  const CombatStartedHistoryEntry({required super.tick, required this.combatants});
  final List<Combatant> combatants;

  @override
  List<CombatReplayCombatant> applyTo(List<CombatReplayCombatant> combatants) =>
      this.combatants.map(CombatReplayCombatant.fromCombatant).toList();
}
