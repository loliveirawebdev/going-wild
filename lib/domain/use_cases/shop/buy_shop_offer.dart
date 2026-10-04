import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/inventory/errors/inventory_is_full_error.dart';
import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/player/errors/not_enough_coins_error.dart';
import 'package:going_wild/domain/models/roster/roster.dart';
import 'package:going_wild/domain/models/shop/errors/empty_shop_offer_error.dart';

RejectedPlayerActionError? checkBuyingShopOffer(MatchProgress matchProgress, {required int offerIndex}) {
  if (matchProgress.checkPreparingActions() case final rejection?) return rejection;

  final offeredCharacter = matchProgress.shop.offerAt(offerIndex);
  if (offeredCharacter == null) return EmptyShopOfferError(offerIndex: offerIndex);

  final player = matchProgress.player;
  final price = matchProgress.phase.engines.economyEngine.priceOf(offeredCharacter, matchProgress: matchProgress);
  if (!player.canAfford(price)) return NotEnoughCoinsError(costInCoins: price, coins: player.coins);
  if (_rosterAfterPurchase(matchProgress, offerIndex: offerIndex) == null) return InventoryIsFullError();

  return null;
}

MatchProgress buyShopOffer(MatchProgress matchProgress, {required int offerIndex}) {
  if (checkBuyingShopOffer(matchProgress, offerIndex: offerIndex) case final rejection?) throw rejection;
  final offeredCharacter = matchProgress.shop.offerAt(offerIndex)!;
  final price = matchProgress.phase.engines.economyEngine.priceOf(offeredCharacter, matchProgress: matchProgress);

  return matchProgress.createCopyWith(
    shop: matchProgress.shop.createCopyWithoutOfferAt(offerIndex),
    player: matchProgress.player.createCopyWithCoinsSpent(price),
    playerRoster: _rosterAfterPurchase(matchProgress, offerIndex: offerIndex)!,
  );
}

Roster? _rosterAfterPurchase(MatchProgress matchProgress, {required int offerIndex}) {
  final engines = matchProgress.phase.engines;
  final boughtCharacterCopy = CharacterCopy(stars: 1, character: matchProgress.shop.offerAt(offerIndex)!);

  return engines.mergeEngine.mergeWithNewCopy(
    matchProgress.playerRoster,
    boughtCharacterCopy,
    inventoryEngine: engines.inventoryEngine,
    maxStars: engines.characterEngine.maxStars,
  );
}
