import 'package:going_wild/content/engines/shop/basic_shop_engine.dart';
import 'package:going_wild/domain/models/shop/engines/basic_shop_engine.dart';

const testShopEngine = basicShopEngine;

BasicShopEngine basicShopEngineWith({int? maxOddsPercentagePerCharacter}) => BasicShopEngine(
  size: basicShopEngine.size,
  purchasableCharacters: basicShopEngine.purchasableCharacters,
  rarityOddsPercentageByLevelNumber: basicShopEngine.rarityOddsPercentageByLevelNumber,
  maxOddsPercentagePerCharacter: maxOddsPercentagePerCharacter ?? basicShopEngine.maxOddsPercentagePerCharacter,
);
