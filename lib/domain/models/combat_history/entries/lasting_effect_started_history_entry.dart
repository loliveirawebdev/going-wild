part of 'combat_history_entry.dart';

class LastingEffectStartedHistoryEntry extends CombatHistoryEntry {
  const LastingEffectStartedHistoryEntry({required super.tick, required this.combatantId, required this.combatLastingEffect});
  final CombatLastingEffect combatLastingEffect;
  final int combatantId;
}
