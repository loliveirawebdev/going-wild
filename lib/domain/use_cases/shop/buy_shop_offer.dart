import '../../models/shop/merge_owned_characters.dart';
import '../../models/shop/owned_character.dart';
import '../../models/player/player.dart';
import '../../models/shop/shop_rules.dart';

bool buyShopOffer(Player player, ShopRules rules, int offerIndex) {
  final offeredCharacter = player.shopOffers[offerIndex];
  if (offeredCharacter == null || player.coins < offeredCharacter.rarity.coins) return false;

  player.coins -= offeredCharacter.rarity.coins;
  player.shopOffers[offerIndex] = null;
  player.ownedCharacters.add(OwnedCharacter(character: offeredCharacter, stars: 1));
  mergeOwnedCharacters(player, rules);
  return true;
}
