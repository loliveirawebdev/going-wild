import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/models/character/stars/merge_curve.dart';
import 'package:going_wild/domain/models/character/stars/star_values.dart';
import 'package:going_wild/domain/models/character/stats/errors/missing_stat_error.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stat_change_type.dart';
import 'package:going_wild/domain/models/character/stats/stat_modification.dart';
import 'package:going_wild/domain/models/character/stats/stat_multipliers.dart';
import 'package:going_wild/domain/models/character/stats/stats.dart';

void main() {
  const stats = Stats({
    Stat.health: 100,
    Stat.damage: 10,
    Stat.armor: 5,
    Stat.attackSpeed: 0.7,
    Stat.moveSpeed: 1,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 60,
    Stat.range: 1,
  });

  test('operator [] and createCopyWithStat round-trip every stat', () {
    for (final stat in Stat.values) {
      final changedStats = stats.createCopyWithStat(stat, 42);
      expect(changedStats[stat], 42, reason: '$stat');

      for (final otherStat in Stat.values.where((candidate) => candidate != stat)) {
        expect(
          changedStats[otherStat],
          stats[otherStat],
          reason: '$stat changed $otherStat',
        );
      }
    }
  });

  test('createCopyWithStat does not mutate the original', () {
    final _ = stats.createCopyWithStat(Stat.health, 1);
    expect(stats[Stat.health], 100);
  });

  test('reading a stat without value throws MissingStatError', () {
    const incompleteStats = Stats({Stat.health: 100});
    expect(() => incompleteStats[Stat.damage], throwsA(isA<MissingStatError>()));
  });

  test('undefined multipliers default to 1 and only the given stats count as defined', () {
    const multipliers = StatMultipliers({Stat.health: 2});

    expect(multipliers[Stat.health], 2);
    expect(multipliers[Stat.damage], 1);
    expect(multipliers.definedStats, {Stat.health});
  });

  test('undefined merge curve stats stay at 1 for every star', () {
    const mergeCurve = MergeCurve({Stat.health: StarValues(star1: 1, star2: 2, star3: 4)});
    expect(mergeCurve[Stat.health].at(3), 4);

    for (final stars in [1, 2, 3]) {
      expect(
        mergeCurve[Stat.damage].at(stars),
        1,
        reason: '$stars',
      );
    }
  });

  test('applyStatModifications multiplies first and adds after', () {
    const statModifications = [
      StatModification(value: 5, stat: Stat.damage, changeType: StatChangeType.absoluteValue),
      StatModification(value: 2, stat: Stat.damage, changeType: StatChangeType.multiplier),
    ];

    expect(applyStatModifications(10, statModifications), 25);
  });

  test('applyStatModifications without modifications keeps the base value', () {
    expect(applyStatModifications(10, const []), 10);
  });
}
