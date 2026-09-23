import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/team/merge_curves/merge_curves.dart';
import 'package:going_wild/domain/models/models.dart';

void main() {
  List<StarValues> statsOf(MergeCurve c) => [
    c.health,
    c.damage,
    c.armor,
    c.shield,
    c.attackSpeed,
    c.damageTakenPercentage,
    c.mana,
    c.range,
  ];

  test('mergeCurveFor covers every role with its own curve', () {
    final curves = Role.values.map(mergeCurveFor).toSet();
    expect(curves.length, Role.values.length);
  });

  for (final role in Role.values) {
    final curve = mergeCurveFor(role);

    test('$role star 1 is neutral', () {
      for (final s in statsOf(curve)) {
        expect(s.star1, 1);
      }
    });

    test('$role never shrinks a stat with stars', () {
      for (final s in statsOf(curve)) {
        expect(s.star2, greaterThanOrEqualTo(s.star1));
        expect(s.star3, greaterThanOrEqualTo(s.star2));
      }
    });

    test('$role star 3 is star 2 squared', () {
      for (final s in statsOf(curve)) {
        expect(s.star3, closeTo(s.star2 * s.star2, 0.01));
      }
    });

    test('$role does not scale attack speed, range or mana', () {
      for (final s in [curve.attackSpeed, curve.range, curve.mana]) {
        expect([s.star1, s.star2, s.star3], everyElement(1));
      }
    });
  }
}
