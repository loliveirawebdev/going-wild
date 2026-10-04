import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/engines/economy/basic_economy_engine.dart';
import 'package:going_wild/content/engines/inventory/basic_inventory_engine.dart';
import 'package:going_wild/content/engines/player/basic_player_engine.dart';
import 'package:going_wild/content/engines/shop/basic_shop_engine.dart';
import 'package:going_wild/domain/models/phase/phase_status.dart';

import '../../../helpers/use_case_helpers.dart';

void main() {
  group('starting a match', () {
    test('starts at round 1 with the first wave reward, level 2 after the round experience and a full shop', () {
      final matchProgress = startWith([oneRat, oneRat]);

      expect(matchProgress.currentRoundNumber, 1);
      expect(matchProgress.status, PhaseStatus.inProgress);
      expect(matchProgress.player.coins, basicEconomyEngine.startingCoins + oneRat.coinsReward);
      expect(matchProgress.player.remainingLives, basicPlayerEngine.startingLives);
      expect(matchProgress.playerLevelProgress.level.number, 2);
      expect(matchProgress.shop.offers, hasLength(basicShopEngine.size));
      expect(matchProgress.shop.offers, everyElement(isNotNull));
      expect(matchProgress.playerRoster.inventory.capacity, basicCharacterInventoryEngine.capacity);
      expect(matchProgress.playerRoster.placements, isEmpty);
    });

    test('the same seed starts the same match', () {
      expect(startWith([oneRat], seed: 9).shop.offers, startWith([oneRat], seed: 9).shop.offers);
    });
  });
}
