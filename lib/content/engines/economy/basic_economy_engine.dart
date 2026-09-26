import 'package:going_wild/domain/models/character/rarity.dart';
import 'package:going_wild/domain/models/economy/engines/basic_economy_engine.dart';

const BasicEconomyEngine basicEconomyEngine = BasicEconomyEngine(
  startingCoins: 0,
  priceInCoinsByRarity: {Rarity.common: 1, Rarity.uncommon: 2, Rarity.rare: 3, Rarity.epic: 4},
  mergedCharacterSellDiscountInCoins: 1,
  rerollCostInCoins: 2,
  experiencePurchaseCostInCoins: 4,
  experiencePerPurchase: 4,
);
