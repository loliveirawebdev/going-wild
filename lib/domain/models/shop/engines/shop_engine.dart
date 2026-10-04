import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/shop/shop.dart';

abstract class ShopEngine {
  const ShopEngine();

  Shop startingShop();
  List<Character?> pickOffers({required MatchProgress matchProgress});
}
