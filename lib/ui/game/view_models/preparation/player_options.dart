import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/player/errors/not_enough_coins_error.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';
import 'package:going_wild/domain/use_cases/level/buy_experience.dart';
import 'package:going_wild/domain/use_cases/lineup/move_copy_between_roster_slots.dart';
import 'package:going_wild/domain/use_cases/lineup/sell_copy_from_roster_slot.dart';
import 'package:going_wild/domain/use_cases/round/start_fight.dart';
import 'package:going_wild/domain/use_cases/shop/buy_shop_offer.dart';
import 'package:going_wild/domain/use_cases/shop/reroll_shop.dart';
import 'package:going_wild/domain/use_cases/shop/toggle_shop_lock.dart';

enum ShopOfferStatus {
  available,
  sold,
  locked,
  unaffordable,
}

typedef ShopOfferOption = ({
  int priceInCoins,
  Character character,
  ShopOfferStatus status,
  RejectedPlayerActionError? rejection,
});

typedef CostedOption = ({int costInCoins, RejectedPlayerActionError? rejection});

typedef SaleOption = ({int valueInCoins, RejectedPlayerActionError? rejection});

class PlayerOptions {
  const PlayerOptions(this._matchProgress);

  final MatchProgress _matchProgress;

  bool get canRearrangeRoster => _matchProgress.checkPreparingActions() == null;

  RejectedPlayerActionError? get fightRejection => checkStartingFight(_matchProgress);
  RejectedPlayerActionError? get shopLockRejection => checkTogglingShopLock(_matchProgress);

  RejectedPlayerActionError? moveRejectionOf({required RosterSlot from, required RosterSlot to}) =>
      checkMovingCopyBetweenRosterSlots(_matchProgress, to: to, from: from);

  CostedOption get reroll => (
    rejection: checkRerollingShop(_matchProgress),
    costInCoins: _matchProgress.phase.engines.economyEngine.rerollCostInCoins(matchProgress: _matchProgress),
  );

  CostedOption get experiencePurchase => (
    rejection: checkBuyingExperience(_matchProgress),
    costInCoins: _matchProgress.phase.engines.economyEngine.experiencePurchaseCostInCoins(matchProgress: _matchProgress),
  );

  ShopOfferOption? shopOfferAt(int offerIndex) {
    final shop = _matchProgress.shop;
    final character = shop.offers[offerIndex] ?? shop.soldOfferAt(offerIndex);
    if (character == null) return null;

    final rejection = checkBuyingShopOffer(_matchProgress, offerIndex: offerIndex);
    final status = switch (rejection) {
      _ when shop.offers[offerIndex] == null => ShopOfferStatus.sold,
      _ when !canRearrangeRoster => ShopOfferStatus.locked,
      NotEnoughCoinsError() => ShopOfferStatus.unaffordable,
      _ => ShopOfferStatus.available,
    };

    return (
      status: status,
      rejection: rejection,
      character: character,
      priceInCoins: _matchProgress.phase.engines.economyEngine.priceOf(character, matchProgress: _matchProgress),
    );
  }

  SaleOption saleOf(CharacterCopy characterCopy) {
    final rosterSlot = slotOf(characterCopy);

    return (
      valueInCoins: _matchProgress.phase.engines.economyEngine.sellPriceOf(characterCopy, matchProgress: _matchProgress),
      rejection: rosterSlot == null
          ? _matchProgress.checkPreparingActions()
          : checkSellingCopyFromRosterSlot(_matchProgress, from: rosterSlot),
    );
  }

  RosterSlot? slotOf(CharacterCopy characterCopy) =>
      _matchProgress.playerRoster.entries.where((entry) => identical(entry.characterCopy, characterCopy)).firstOrNull?.slot;
}
