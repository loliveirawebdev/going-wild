import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/models/models.dart';

void main() {
  const stats = Stats(
    health: 100,
    damage: 10,
    armor: 5,
    shield: 0,
    attackSpeed: 0.7,
    moveSpeed: 1,
    damageTakenPercentage: 1,
    manaStart: 0,
    manaMax: 60,
    range: 1,
  );

  test('operator [] and withStat round-trip every stat', () {
    for (final stat in Stat.values) {
      final changed = stats.withStat(stat, 42);
      expect(changed[stat], 42, reason: '$stat');
      for (final other in Stat.values.where((s) => s != stat)) {
        expect(
          changed[other],
          stats[other],
          reason: '$stat changed $other',
        );
      }
    }
  });

  test('copyWith changes only the given field', () {
    final changed = stats.copyWith(damage: 99);
    expect(changed.damage, 99);

    for (final stat in Stat.values.where((s) => s != Stat.damage)) {
      expect(
        changed[stat],
        stats[stat],
        reason: '$stat',
      );
    }
  });

  test('withStat does not mutate the original', () {
    stats.withStat(Stat.health, 1);
    expect(stats.health, 100);
  });

  test('undefined multipliers default to 1', () {
    const multipliers = StatMultipliers({Stat.health: 2});
    expect(multipliers[Stat.health], 2);
    expect(multipliers[Stat.damage], 1);
    expect(multipliers.defines(Stat.health), isTrue);
    expect(multipliers.defines(Stat.damage), isFalse);
  });

  test('undefined merge curve stats stay at 1 for every star', () {
    const curve = MergeCurve({Stat.health: StarValues(star1: 1, star2: 2, star3: 4)});
    expect(curve[Stat.health].at(3), 4);

    for (final stars in [1, 2, 3]) {
      expect(
        curve[Stat.damage].at(stars),
        1,
        reason: '$stars',
      );
    }

    expect(curve.defines(Stat.damage), isFalse);
  });
}
