import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/base_stats.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';

void main() {
  test('the base defines every stat', () {
    for (final stat in Stat.values) {
      expect(() => baseStats[stat], returnsNormally, reason: '$stat');
    }
  });
}
