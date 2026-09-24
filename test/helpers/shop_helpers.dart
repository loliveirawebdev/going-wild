import 'package:going_wild/data/character/team/team.dart';
import 'package:going_wild/data/player/player_levels.dart';
import 'package:going_wild/data/shop/shop_rules.dart';
import 'package:going_wild/domain/models/models.dart';
import 'package:going_wild/domain/models/player/player.dart';
import 'package:going_wild/domain/models/shop/owned_character.dart';
import 'package:going_wild/domain/models/shop/shop_rules.dart';

const testShopRules = ShopRules(
  maxStars: maxStars,
  shopSize: shopSize,
  playerLevels: playerLevels,
  coinsPerRound: coinsPerRound,
  copiesPerMerge: copiesPerMerge,
  rerollCostInCoins: rerollCostInCoins,
  experiencePerRound: experiencePerRound,
  purchasableCharacters: allTeamCharacters,
  experiencePerPurchase: experiencePerPurchase,
  experiencePurchaseCostInCoins: experiencePurchaseCostInCoins,
  maxShopOddsPercentagePerCharacter: maxShopOddsPercentagePerCharacter,
);

Player playerWith({int coins = 0, int level = 1, int experience = 0, List<OwnedCharacter> ownedCharacters = const []}) {
  final player = Player(coins: coins)
    ..level = level
    ..experience = experience;
  player.ownedCharacters.addAll(ownedCharacters);
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
      coinsPerRound: coinsPerRound,
      copiesPerMerge: copiesPerMerge,
      rerollCostInCoins: rerollCostInCoins,
      experiencePerRound: experiencePerRound,
      purchasableCharacters: allTeamCharacters,
      experiencePerPurchase: experiencePerPurchase,
      experiencePurchaseCostInCoins: experiencePurchaseCostInCoins,
      maxShopOddsPercentagePerCharacter: maxShopOddsPercentagePerCharacter,
    );
