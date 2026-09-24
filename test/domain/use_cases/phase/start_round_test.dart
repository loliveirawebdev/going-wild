import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/models/events/phase/phase_event.dart';
import 'package:going_wild/domain/use_cases/phase/start_round.dart';

import '../../../helpers/phase_helpers.dart';
import '../../../helpers/shop_helpers.dart';

void main() {
  test('a new round pays coins, grants experience and refreshes the shop for free', () {
    final phaseRun = phaseRunWith(coins: 3, level: 4);

    startRound(phaseRun);

    expect(phaseRun.player.coins, 3 + phaseRun.currentEnemyWave.coinsReward);
    expect(phaseRun.player.experience, testShopRules.experiencePerRound);
    expect(phaseRun.player.shopOffers, hasLength(testShopRules.shopSize));
    expect(phaseRun.player.shopOffers, everyElement(isNotNull));
  });

  test('records the round start, the coins, the experience and the new shop in that order', () {
    final phaseRun = phaseRunWith(coins: 3, level: 4);

    startRound(phaseRun);

    expect(phaseRun.events, [isA<RoundStarted>(), isA<PlayerReceivedCoins>(), isA<PlayerReceivedExperience>(), isA<ShopOffersRefreshed>()]);
    expect(phaseRun.events, everyElement(predicate<PhaseEvent>((event) => event.roundNumber == phaseRun.currentRoundNumber)));
    final coinsReceived = phaseRun.events.whereType<PlayerReceivedCoins>().single;
    expect(coinsReceived.amount, phaseRun.currentEnemyWave.coinsReward);
    expect(coinsReceived.coinsAfterReceived, 3 + phaseRun.currentEnemyWave.coinsReward);
  });

  test('the first round takes a new player from level 1 to level 2', () {
    final phaseRun = phaseRunWith();

    startRound(phaseRun);

    expect(phaseRun.player.level, 2);
    expect(phaseRun.player.experience, 0);
    expect(phaseRun.events.whereType<PlayerLeveledUp>().single.newLevel, 2);
  });

  test('bought slots come back filled on the next round', () {
    final phaseRun = phaseRunWith(level: 3, shopOffers: [null, null, null, null]);

    startRound(phaseRun);

    expect(phaseRun.player.shopOffers, everyElement(isNotNull));
  });
}
