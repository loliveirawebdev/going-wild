import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/models/player/level/gain_experience.dart';

import '../../../../helpers/shop_helpers.dart';

void main() {
  int experienceToLeave(int level) => testShopRules.playerLevels[level - 1].experienceToNextLevel;

  test('experience below the threshold keeps the level', () {
    final player = playerWith(level: 4);

    gainExperience(player, testShopRules, experienceToLeave(4) - 1);

    expect(player.level, 4);
    expect(player.experience, experienceToLeave(4) - 1);
  });

  test('reaching the threshold levels up and keeps the leftover', () {
    final player = playerWith(level: 4, experience: 3);

    gainExperience(player, testShopRules, experienceToLeave(4));

    expect(player.level, 5);
    expect(player.experience, 3);
  });

  test('a big amount climbs several levels at once', () {
    final player = playerWith(level: 1);

    gainExperience(player, testShopRules, experienceToLeave(1) + experienceToLeave(2) + experienceToLeave(3) + 1);

    expect(player.level, 4);
    expect(player.experience, 1);
  });

  test('reaching max level clears the leftover', () {
    final player = playerWith(level: testShopRules.maxLevel - 1);

    gainExperience(player, testShopRules, experienceToLeave(testShopRules.maxLevel - 1) + 50);

    expect(player.level, testShopRules.maxLevel);
    expect(player.experience, 0);
  });

  test('at max level experience is ignored', () {
    final player = playerWith(level: testShopRules.maxLevel);

    gainExperience(player, testShopRules, 100);

    expect(player.level, testShopRules.maxLevel);
    expect(player.experience, 0);
  });
}
