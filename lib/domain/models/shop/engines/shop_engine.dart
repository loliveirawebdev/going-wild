import 'dart:math';

import '../../character/character.dart';
import '../../roster/roster.dart';
import '../shop.dart';

abstract class ShopEngine {
  const ShopEngine();

  Shop startingShop();
  List<Character?> pickOffers({required int maxStars, required Roster roster, required int levelNumber, required Random randomGenerator});
}
