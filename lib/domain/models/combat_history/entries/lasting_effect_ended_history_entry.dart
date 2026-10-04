part of 'combat_history_entry.dart';

class LastingEffectEndedHistoryEntry extends CombatConsequenceHistoryEntry {
  const LastingEffectEndedHistoryEntry({
    required super.tick,
    required super.cause,
    required super.combatantId,
    required this.combatLastingEffect,
  });

  final CombatLastingEffect combatLastingEffect;

  static List<LastingEffectEndedHistoryEntry> detectedIn(CombatantStepComparison comparison) => [
    for (final endedEffect in comparison.matchedEffects.endedEffects)
      LastingEffectEndedHistoryEntry(
        tick: comparison.tick,
        cause: comparison.cause,
        combatantId: comparison.after.id,
        combatLastingEffect: endedEffect,
      ),
  ];

  @override
  CombatReplayCombatant applyToCombatant(CombatReplayCombatant combatant) => combatant.createCopyWithoutLastingEffect(combatLastingEffect);
}
