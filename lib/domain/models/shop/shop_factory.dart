import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/shop/shop.dart';

class ShopFactory {
  static Shop empty({required int size}) {
    return Shop(offers: List.unmodifiable(List<Character?>.filled(size, null)), isLocked: false);
  }
}
