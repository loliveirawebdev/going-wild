part of 'combat_history_entry.dart';

class LastingEffectChangedHistoryEntry extends CombatConsequenceHistoryEntry {
  const LastingEffectChangedHistoryEntry({
    required super.tick,
    required super.cause,
    required super.combatantId,
    required this.combatLastingEffectAfter,
    required this.combatLastingEffectBefore,
  });

  final CombatLastingEffect combatLastingEffectAfter;
  final CombatLastingEffect combatLastingEffectBefore;

  static List<LastingEffectChangedHistoryEntry> detectedIn(CombatantStepComparison comparison) => [
    for (final changedEffect in comparison.matchedEffects.changedEffects)
      LastingEffectChangedHistoryEntry(
        tick: comparison.tick,
        cause: comparison.cause,
        combatantId: comparison.after.id,
        combatLastingEffectAfter: changedEffect.after,
        combatLastingEffectBefore: changedEffect.before,
      ),
  ];

  @override
  CombatReplayCombatant applyToCombatant(CombatReplayCombatant combatant) =>
      combatant.createCopyWithLastingEffectReplaced(combatLastingEffectBefore, replacement: combatLastingEffectAfter);
}
