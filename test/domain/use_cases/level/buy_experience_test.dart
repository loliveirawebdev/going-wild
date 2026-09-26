import 'package:going_wild/content/engines/economy/basic_economy_engine.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/level/player_levels.dart';
import 'package:going_wild/domain/models/level/errors/max_level_reached_error.dart';
import 'package:going_wild/domain/models/level/player_level_progress.dart';
import 'package:going_wild/domain/models/player/errors/not_enough_coins_error.dart';

import '../../../helpers/use_case_helpers.dart';

void main() {
  group('experience', () {
    test('buying experience pays for it and levels up keeping the leftover', () {
      final matchProgress = startWith([oneRat]);

      final leveled = buyExperience(matchProgress);

      expect(leveled.player.coins, matchProgress.player.coins - basicEconomyEngine.experiencePurchaseCostInCoins);
      expect(leveled.playerLevelProgress.level.number, 3);
      expect(leveled.playerLevelProgress.experience, basicEconomyEngine.experiencePerPurchase - playerLevels[1].experienceToNextLevel);
    });

    test('without coins it fails', () {
      final matchProgress = withCoins(startWith([oneRat]), 0);
      expect(() => buyExperience(matchProgress), throwsA(isA<NotEnoughCoinsError>()));
    });
  });

  test('buying experience at the max level fails', () {
    final matchProgress = withCoins(startWith([oneRat]), 100).createCopyWith(
      playerLevelProgress: PlayerLevelProgress(experience: 0, level: playerLevels.last),
    );
    expect(() => buyExperience(matchProgress), throwsA(isA<MaxLevelReachedError>()));
  });
}
