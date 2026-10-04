import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/domain/models/board/errors/position_outside_team_half_error.dart';
import 'package:going_wild/domain/models/board/errors/team_is_full_error.dart';
import 'package:going_wild/domain/models/inventory/errors/empty_inventory_slot_error.dart';
import 'package:going_wild/domain/models/inventory/errors/inventory_is_full_error.dart';
import 'package:going_wild/domain/models/match_progress/errors/fight_in_progress_error.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/player/errors/not_enough_coins_error.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';
import 'package:going_wild/domain/models/shop/errors/empty_shop_offer_error.dart';
import 'package:going_wild/domain/use_cases/round/start_fight.dart';

import '../../helpers/inventory_helpers.dart';
import '../../helpers/use_case_helpers.dart';

MatchProgress preparedMatchProgress() {
  final withOffers = withShopOffers(matchProgressWith(waves: const [oneRat, fiveRats]), [cat, null, null, null]);
  return withCoins(withInventory(withOffers, [characterCopyOf(cow)]), 20).createCopyWithPlayerPlacements([placed(dog, 6, 2)]);
}

void main() {
  test('every check passes when the action is allowed', () {
    final matchProgress = preparedMatchProgress();

    expect(checkStartingFight(matchProgress), isNull);
    expect(checkRerollingShop(matchProgress), isNull);
    expect(checkBuyingExperience(matchProgress), isNull);
    expect(checkTogglingShopLock(matchProgress), isNull);
    expect(checkBuyingShopOffer(matchProgress, offerIndex: 0), isNull);
    expect(checkSellingCopyFromRosterSlot(matchProgress, from: const InventorySlot(index: 0)), isNull);
    expect(
      checkMovingCopyBetweenRosterSlots(
        matchProgress,
        to: BoardSlot(position: at(6, 3)),
        from: BoardSlot(position: at(6, 2)),
      ),
      isNull,
    );
  });

  test('a check gives the same rejection the action throws', () {
    final matchProgress = preparedMatchProgress();
    final poorMatchProgress = withCoins(matchProgress, 0);
    final fullInventoryMatchProgress = withInventory(matchProgress, [characterCopyOf(dog)], capacity: 1);

    expect(checkBuyingShopOffer(matchProgress, offerIndex: 1), isA<EmptyShopOfferError>());
    expect(checkBuyingShopOffer(poorMatchProgress, offerIndex: 0), isA<NotEnoughCoinsError>());
    expect(checkBuyingShopOffer(fullInventoryMatchProgress, offerIndex: 0), isA<InventoryIsFullError>());
    expect(() => buyShopOffer(fullInventoryMatchProgress, offerIndex: 0), throwsA(isA<InventoryIsFullError>()));
    expect(checkRerollingShop(poorMatchProgress), isA<NotEnoughCoinsError>());
    expect(checkBuyingExperience(poorMatchProgress), isA<NotEnoughCoinsError>());
  });

  test('moving checks the destination as well as the origin', () {
    final matchProgress = preparedMatchProgress();
    const cowInInventory = InventorySlot(index: 0);

    final enemyHalf = BoardSlot(position: at(0, 0));
    final freeTeamSpot = BoardSlot(position: at(6, 3));

    expect(checkMovingCopyBetweenRosterSlots(matchProgress, to: enemyHalf, from: cowInInventory), isA<PositionOutsideTeamHalfError>());
    expect(checkMovingCopyBetweenRosterSlots(matchProgress, to: freeTeamSpot, from: cowInInventory), isA<TeamIsFullError>());
    expect(
      checkMovingCopyBetweenRosterSlots(matchProgress, to: freeTeamSpot, from: const InventorySlot(index: 1)),
      isA<EmptyInventorySlotError>(),
    );
  });

  test('while fighting, every preparing check gives the fight in progress', () {
    final fightingMatchProgress = startFight(preparedMatchProgress(), recordsHistory: false).fightingMatchProgress;

    expect(checkStartingFight(fightingMatchProgress), isA<FightInProgressError>());
    expect(checkRerollingShop(fightingMatchProgress), isA<FightInProgressError>());
    expect(checkBuyingExperience(fightingMatchProgress), isA<FightInProgressError>());
    expect(checkTogglingShopLock(fightingMatchProgress), isA<FightInProgressError>());
    expect(checkBuyingShopOffer(fightingMatchProgress, offerIndex: 0), isA<FightInProgressError>());
    expect(checkSellingCopyFromRosterSlot(fightingMatchProgress, from: const InventorySlot(index: 0)), isA<FightInProgressError>());
  });
}
