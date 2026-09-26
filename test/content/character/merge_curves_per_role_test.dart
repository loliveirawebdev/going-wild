import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/merge_curves_per_role/merge_curves_per_role.dart';
import 'package:going_wild/domain/models/character/role.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';

void main() {
  test('mergeCurveForRole covers every role with its own curve', () {
    final mergeCurves = Role.values.map(mergeCurveForRole).toSet();
    expect(mergeCurves, hasLength(Role.values.length));
  });

  for (final role in Role.values) {
    final mergeCurve = mergeCurveForRole(role);

    test('$role defines every stat explicitly', () {
      expect(mergeCurve.definedStats, Stat.values.toSet());
    });

    test('$role star 1 is neutral', () {
      for (final stat in Stat.values) {
        expect(
          mergeCurve[stat].star1,
          1,
          reason: '$stat',
        );
      }
    });

    test('$role never shrinks a stat with stars', () {
      for (final stat in Stat.values) {
        expect(mergeCurve[stat].star2, greaterThanOrEqualTo(mergeCurve[stat].star1), reason: '$stat');
        expect(mergeCurve[stat].star3, greaterThanOrEqualTo(mergeCurve[stat].star2), reason: '$stat');
      }
    });

    test('$role star 3 is star 2 squared', () {
      for (final stat in Stat.values) {
        expect(mergeCurve[stat].star3, closeTo(mergeCurve[stat].star2 * mergeCurve[stat].star2, 0.01), reason: '$stat');
      }
    });

    test('$role scales health and damage and nothing that is not a combat number', () {
      expect(mergeCurve[Stat.health].star2, greaterThan(1));
      expect(mergeCurve[Stat.damage].star2, greaterThan(1));

      for (final stat in [Stat.attackSpeed, Stat.manaStart, Stat.manaMax, Stat.range]) {
        expect(
          [mergeCurve[stat].star1, mergeCurve[stat].star2, mergeCurve[stat].star3],
          everyElement(1),
          reason: '$stat',
        );
      }
    });
  }
}
