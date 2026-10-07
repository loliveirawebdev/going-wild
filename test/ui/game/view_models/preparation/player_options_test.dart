import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/phase/backyard/backyard.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/match_progress/errors/fight_in_progress_error.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/player/errors/not_enough_coins_error.dart';
import 'package:going_wild/domain/models/player/player.dart';
import 'package:going_wild/domain/use_cases/lineup/move_from_inventory_to_board.dart';
import 'package:going_wild/domain/use_cases/round/start_fight.dart';
import 'package:going_wild/domain/use_cases/round/start_match.dart';
import 'package:going_wild/domain/use_cases/shop/buy_shop_offer.dart';
import 'package:going_wild/ui/game/view_models/preparation/player_options.dart';

MatchProgress withoutCoins(MatchProgress matchProgress) =>
    matchProgress.createCopyWith(player: Player(coins: 0, remainingLives: matchProgress.player.remainingLives));

void main() {
  final startedMatch = startMatch(backyard, randomGenerator: Random(1));
  final firstOfferIndex = startedMatch.shop.offers.indexWhere((offer) => offer != null);

  test('a shop offer is available, unaffordable without coins, sold once bought and locked during the fight', () {
    expect(PlayerOptions(startedMatch).shopOfferAt(firstOfferIndex)!.status, ShopOfferStatus.available);

    final unaffordable = PlayerOptions(withoutCoins(startedMatch)).shopOfferAt(firstOfferIndex)!;
    expect(unaffordable.status, ShopOfferStatus.unaffordable);
    expect(unaffordable.rejection, isA<NotEnoughCoinsError>());

    final afterBuying = buyShopOffer(startedMatch, offerIndex: firstOfferIndex);
    expect(PlayerOptions(afterBuying).shopOfferAt(firstOfferIndex)!.status, ShopOfferStatus.sold);

    final fighting = startFight(startedMatch, recordsHistory: false).fightingMatchProgress;
    expect(PlayerOptions(fighting).shopOfferAt(firstOfferIndex)!.status, ShopOfferStatus.locked);
  });

  test('rerolling, buying experience and rearranging follow the coins and the round stage', () {
    expect(PlayerOptions(startedMatch).reroll.rejection, isNull);
    expect(PlayerOptions(startedMatch).canRearrangeRoster, isTrue);
    expect(PlayerOptions(withoutCoins(startedMatch)).reroll.rejection, isA<NotEnoughCoinsError>());
    expect(PlayerOptions(withoutCoins(startedMatch)).experiencePurchase.rejection, isA<NotEnoughCoinsError>());

    final fighting = startFight(startedMatch, recordsHistory: false).fightingMatchProgress;
    expect(PlayerOptions(fighting).canRearrangeRoster, isFalse);
    expect(PlayerOptions(fighting).shopLockRejection, isA<FightInProgressError>());
  });

  test('the same animal sells for the same value with the same reason from the bench, the field or the fight', () {
    final withCopyOnBench = buyShopOffer(startedMatch, offerIndex: firstOfferIndex);
    final benchCopy = withCopyOnBench.playerRoster.inventory.entries.single;
    final benchSale = PlayerOptions(withCopyOnBench).saleOf(benchCopy);
    expect(benchSale.rejection, isNull);
    expect(benchSale.valueInCoins, greaterThan(0));

    final withCopyOnField = moveFromInventoryToBoard(withCopyOnBench, inventoryIndex: 0, position: const Position(row: 6, column: 1));
    final fieldSale = PlayerOptions(withCopyOnField).saleOf(benchCopy);
    expect(fieldSale.rejection, isNull);
    expect(fieldSale.valueInCoins, benchSale.valueInCoins);

    final fighting = startFight(withCopyOnField, recordsHistory: false).fightingMatchProgress;
    final fightSale = PlayerOptions(fighting).saleOf(benchCopy);
    expect(fightSale.rejection, isA<FightInProgressError>());
    expect(fightSale.valueInCoins, benchSale.valueInCoins);
  });
}
