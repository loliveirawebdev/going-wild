import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/models/character/stars/merge_curve.dart';
import 'package:going_wild/domain/models/character/stars/star_values.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';

void main() {
  const mergeCurve = MergeCurve({Stat.health: StarValues(star1: 1, star2: 2, star3: 4)});

  test('a defined stat returns its values per star', () {
    expect(mergeCurve[Stat.health].at(3), 4);
  });

  test('only the given stats count as defined', () {
    expect(mergeCurve.definedStats, {Stat.health});
  });

  test('a stat left out does not scale with stars', () {
    expect([1, 2, 3].map((stars) => mergeCurve[Stat.damage].at(stars)), [1, 1, 1]);
  });
}
