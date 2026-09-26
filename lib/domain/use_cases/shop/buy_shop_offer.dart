import '../../models/character/character_copy.dart';
import '../../models/inventory/errors/inventory_is_full_error.dart';
import '../../models/match_progress/match_progress.dart';
import '../../models/player/errors/not_enough_coins_error.dart';
import '../../models/shop/errors/empty_shop_offer_error.dart';

class BuyShopOffer {
  const BuyShopOffer();

  MatchProgress call(MatchProgress matchProgress, {required int offerIndex}) {
    matchProgress.requireInProgress();

    final offeredCharacter = matchProgress.shop.offerAt(offerIndex);
    if (offeredCharacter == null) throw EmptyShopOfferError(offerIndex: offerIndex);

    final player = matchProgress.player;
    final engines = matchProgress.phase.engines;
    final price = engines.economyEngine.priceOf(offeredCharacter);
    if (!player.canAfford(price)) throw NotEnoughCoinsError(costInCoins: price, coins: player.coins);

    final boughtCharacterCopy = CharacterCopy(stars: 1, character: offeredCharacter);

    final rosterAfterPurchase = engines.mergeEngine.mergeWithNewCopy(
      matchProgress.playerRoster,
      boughtCharacterCopy,
      inventoryEngine: engines.inventoryEngine,
      maxStars: engines.characterEngine.maxStars,
    );

    if (rosterAfterPurchase == null) throw InventoryIsFullError();

    return matchProgress.createCopyWith(
      playerRoster: rosterAfterPurchase,
      player: player.createCopyWithCoinsSpent(price),
      shop: matchProgress.shop.createCopyWithoutOfferAt(offerIndex),
    );
  }
}
