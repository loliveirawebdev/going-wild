import '../models/models.dart';

Stats resolveUnitStats({
  required Character character,
  required int stars,
  required Stats base,
  required MergeCurve curve,
}) {
  var stats = base;
  for (final stat in Stat.values) stats = stats.withStat(stat, stats[stat] * character.statMultipliers[stat]);
  for (final stat in Stat.values) stats = stats.withStat(stat, stats[stat] * curve[stat].at(stars));
  return stats;
}
