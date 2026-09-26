import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/models/character/errors/invalid_stars_error.dart';
import 'package:going_wild/domain/models/character/stars/star_values.dart';

void main() {
  const values = StarValues(star1: 10, star2: 15, star3: 22.5);

  test('at returns the value of the given star', () {
    expect(values.at(1), 10);
    expect(values.at(2), 15);
    expect(values.at(3), 22.5);
  });

  test('at rejects stars outside 1 to 3', () {
    expect(() => values.at(0), throwsA(isA<InvalidStarsError>()));
    expect(() => values.at(4), throwsA(isA<InvalidStarsError>()));
  });
}
