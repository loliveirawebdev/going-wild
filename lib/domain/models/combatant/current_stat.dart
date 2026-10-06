import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stat_modification.dart';
import 'package:going_wild/domain/models/character/stats/stats.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/lasting/combat_lasting_effect.dart';

double currentStatOf(Stat stat, {required Stats stats, required List<CombatLastingEffect> combatLastingEffects}) {
  if (combatLastingEffects.isEmpty) return stats[stat];

  final relatedStatModifications = combatLastingEffects
      .map((combatLastingEffect) => combatLastingEffect.statModification)
      .nonNulls
      .where((statModification) => statModification.stat == stat);

  return applyStatModifications(stats[stat], relatedStatModifications);
}

Stats currentStatsOf({required Stats stats, required List<CombatLastingEffect> combatLastingEffects}) => Stats({
  for (final stat in Stat.values) stat: currentStatOf(stat, stats: stats, combatLastingEffects: combatLastingEffects),
});
