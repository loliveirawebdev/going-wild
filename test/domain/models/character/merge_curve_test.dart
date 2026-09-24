import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/models/models.dart';

void main() {
  const mergeCurve = MergeCurve({Stat.health: StarValues(star1: 1, star2: 2, star3: 4)});

  test('a defined stat returns its values per star', () {
    expect(mergeCurve.defines(Stat.health), isTrue);
    expect(mergeCurve[Stat.health].at(3), 4);
  });

  test('a stat left out does not scale with stars', () {
    expect(mergeCurve.defines(Stat.damage), isFalse);
    expect([1, 2, 3].map((stars) => mergeCurve[Stat.damage].at(stars)), [1, 1, 1]);
  });
}
