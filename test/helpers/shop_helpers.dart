import 'package:going_wild/data/character/team/team.dart';
import 'package:going_wild/data/player/player_levels.dart';
import 'package:going_wild/data/shop/shop_rules.dart';
import 'package:going_wild/domain/models/combat/board/position.dart';
import 'package:going_wild/domain/models/models.dart';
import 'package:going_wild/domain/models/player/player.dart';
import 'package:going_wild/domain/models/shop/owned_character.dart';
import 'package:going_wild/domain/models/shop/shop_rules.dart';

const testShopRules = ShopRules(
  maxStars: maxStars,
  shopSize: shopSize,
  playerLevels: playerLevels,
  copiesPerMerge: copiesPerMerge,
  rerollCostInCoins: rerollCostInCoins,
  experiencePerRound: experiencePerRound,
  purchasableCharacters: allTeamCharacters,
  experiencePerPurchase: experiencePerPurchase,
  experiencePurchaseCostInCoins: experiencePurchaseCostInCoins,
  maxShopOddsPercentagePerCharacter: maxShopOddsPercentagePerCharacter,
  mergedCharacterSellDiscountInCoins: mergedCharacterSellDiscountInCoins,
);

Player playerWith({
  int coins = 0,
  int level = 1,
  int experience = 0,
  int benchSize = 9,
  List<OwnedCharacter> benchCharacters = const [],
  Map<Position, OwnedCharacter> fieldCharacters = const {},
}) {
  final player = Player(coins: coins, benchSize: benchSize)
    ..level = level
    ..experience = experience;
  for (final (index, ownedCharacter) in benchCharacters.indexed) player.bench[index] = ownedCharacter;
  player.field.addAll(fieldCharacters);
  return player;
}

OwnedCharacter owned(Character character, {int stars = 1}) => OwnedCharacter(character: character, stars: stars);

List<({Character character, int stars})> ownedCharactersOf(Player player) =>
    player.ownedCharacters.map((ownedCharacter) => (character: ownedCharacter.character, stars: ownedCharacter.stars)).toList();

ShopRules shopRulesWith({int copiesPerMerge = copiesPerMerge, int maxShopOddsPercentagePerCharacter = maxShopOddsPercentagePerCharacter}) =>
    ShopRules(
      maxStars: maxStars,
      shopSize: shopSize,
      playerLevels: playerLevels,
      copiesPerMerge: copiesPerMerge,
      rerollCostInCoins: rerollCostInCoins,
      experiencePerRound: experiencePerRound,
      purchasableCharacters: allTeamCharacters,
      experiencePerPurchase: experiencePerPurchase,
      experiencePurchaseCostInCoins: experiencePurchaseCostInCoins,
      maxShopOddsPercentagePerCharacter: maxShopOddsPercentagePerCharacter,
      mergedCharacterSellDiscountInCoins: mergedCharacterSellDiscountInCoins,
    );
