part of 'combat_history_entry.dart';

class LastingEffectEndedHistoryEntry extends CombatHistoryEntry {
  const LastingEffectEndedHistoryEntry({required super.tick, required this.combatantId, required this.combatLastingEffect});
  final CombatLastingEffect combatLastingEffect;
  final int combatantId;
}
