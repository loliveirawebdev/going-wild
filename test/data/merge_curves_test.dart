import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/merge_curves/merge_curves.dart';
import 'package:going_wild/domain/models/models.dart';

void main() {
  test('mergeCurveFor covers every role with its own curve', () {
    final curves = Role.values.map(mergeCurveFor).toSet();
    expect(curves.length, Role.values.length);
  });

  for (final role in Role.values) {
    final curve = mergeCurveFor(role);

    test('$role defines every stat explicitly', () {
      for (final stat in Stat.values) {
        expect(
          curve.defines(stat),
          isTrue,
          reason: '$stat',
        );
      }
    });

    test('$role star 1 is neutral', () {
      for (final stat in Stat.values) {
        expect(
          curve[stat].star1,
          1,
          reason: '$stat',
        );
      }
    });

    test('$role never shrinks a stat with stars', () {
      for (final stat in Stat.values) {
        expect(curve[stat].star2, greaterThanOrEqualTo(curve[stat].star1), reason: '$stat');
        expect(curve[stat].star3, greaterThanOrEqualTo(curve[stat].star2), reason: '$stat');
      }
    });

    test('$role star 3 is star 2 squared', () {
      for (final stat in Stat.values) {
        expect(curve[stat].star3, closeTo(curve[stat].star2 * curve[stat].star2, 0.01), reason: '$stat');
      }
    });

    test('$role scales health and damage and nothing that is not a combat number', () {
      expect(curve[Stat.health].star2, greaterThan(1));
      expect(curve[Stat.damage].star2, greaterThan(1));

      for (final stat in [Stat.attackSpeed, Stat.manaStart, Stat.manaMax, Stat.range]) {
        expect(
          [curve[stat].star1, curve[stat].star2, curve[stat].star3],
          everyElement(1),
          reason: '$stat',
        );
      }
    });
  }
}
