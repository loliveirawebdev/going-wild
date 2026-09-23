import '../models/models.dart';
import 'active_set_tiers.dart';

Stats resolveUnitStats({
  required Character character,
  required int stars,
  required Stats base,
  required MergeCurve curve,
  required List<ActiveSet> activeSets,
}) {
  var stats = base;
  for (final stat in Stat.values) stats = stats.withStat(stat, stats[stat] * character.statMultipliers[stat]);
  for (final stat in Stat.values) stats = stats.withStat(stat, stats[stat] * curve[stat].at(stars));

  final effects = [
    for (final active in activeSets)
      for (final effect in active.tier.effects)
        if (_reaches(effect, active.set, character, stats)) effect,
  ];

  for (final e in effects.where((e) => e.changeType == StatChangeType.multiplier)) {
    stats = stats.withStat(
      e.stat,
      stats[e.stat] * e.value,
    );
  }

  for (final e in effects.where((e) => e.changeType == StatChangeType.absoluteValue)) {
    stats = stats.withStat(
      e.stat,
      stats[e.stat] + e.value,
    );
  }

  return stats;
}

bool _reaches(SetEffect effect, TeamSet set, Character character, Stats stats) => switch (effect.target) {
  SetTarget.entireTeam => true,
  SetTarget.setMembers => set.members.contains(character),
  SetTarget.teamMelees => stats[Stat.range] == 1,
  SetTarget.teamRangeds => stats[Stat.range] > 1,
  SetTarget.specificCharacter => effect.character == character,
  SetTarget.allEnemies => false,
};
