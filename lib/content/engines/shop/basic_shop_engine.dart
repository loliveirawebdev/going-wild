import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/shop/rarity_odds_percentage_by_level_number.dart';
import 'package:going_wild/domain/models/shop/engines/basic_shop_engine.dart';

const BasicShopEngine basicShopEngine = BasicShopEngine(
  size: 4,
  purchasableCharacters: allTeamCharacters,
  rarityOddsPercentageByLevelNumber: rarityOddsPercentageByLevelNumber,
  maxOddsPercentagePerCharacter: 15,
);
