import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/level/player_levels.dart';

void main() {
  test('each level costs at least as much experience as the one before', () {
    final thresholdsBeforeMaxLevel = playerLevels
        .take(playerLevels.length - 1)
        .map((playerLevel) => playerLevel.experienceToNextLevel)
        .toList();
    expect(thresholdsBeforeMaxLevel, everyElement(greaterThan(0)));
    for (var index = 1; index < thresholdsBeforeMaxLevel.length; index++) {
      expect(thresholdsBeforeMaxLevel[index], greaterThanOrEqualTo(thresholdsBeforeMaxLevel[index - 1]));
    }
  });
}
