import 'package:going_wild/domain/models/shop/engines/basic_shop_engine.dart';

import '../../character/team/team.dart';
import '../../shop/rarity_odds_percentage_by_level_number.dart';

const BasicShopEngine basicShopEngine = BasicShopEngine(
  size: 4,
  purchasableCharacters: allTeamCharacters,
  rarityOddsPercentageByLevelNumber: rarityOddsPercentageByLevelNumber,
  maxOddsPercentagePerCharacter: 15,
);
