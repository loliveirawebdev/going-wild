part of 'combat_history_entry.dart';

class LastingEffectStartedHistoryEntry extends CombatConsequenceHistoryEntry {
  const LastingEffectStartedHistoryEntry({
    required super.tick,
    required super.cause,
    required super.combatantId,
    required this.combatLastingEffect,
  });

  final CombatLastingEffect combatLastingEffect;

  static List<LastingEffectStartedHistoryEntry> detectedIn(CombatantStepComparison comparison) => [
    for (final startedEffect in comparison.matchedEffects.startedEffects)
      LastingEffectStartedHistoryEntry(
        tick: comparison.tick,
        cause: comparison.cause,
        combatantId: comparison.after.id,
        combatLastingEffect: startedEffect,
      ),
  ];

  @override
  CombatReplayCombatant applyToCombatant(CombatReplayCombatant combatant) =>
      combatant.createCopyWithLastingEffectStarted(combatLastingEffect);
}
