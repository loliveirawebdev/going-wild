import '../character/character.dart';
import 'shop.dart';

class ShopFactory {
  static Shop empty({required int size}) {
    return Shop(offers: List.unmodifiable(List<Character?>.filled(size, null)), isLocked: false);
  }
}
