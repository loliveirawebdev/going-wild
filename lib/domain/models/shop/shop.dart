import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/shop/errors/shop_offer_index_out_of_range_error.dart';

class Shop {
  const Shop({required this.offers, required this.isLocked});
  final List<Character?> offers;
  final bool isLocked;

  Character? offerAt(int offerIndex) {
    _checkOfferIndex(offerIndex);
    return offers[offerIndex];
  }

  Shop createCopyLocked() => Shop(offers: offers, isLocked: true);
  Shop createCopyUnlocked() => Shop(offers: offers, isLocked: false);
  Shop createCopyWithOffers(List<Character?> newOffers) => Shop(offers: List.unmodifiable(newOffers), isLocked: isLocked);

  Shop createCopyWithoutOfferAt(int offerIndex) {
    _checkOfferIndex(offerIndex);
    final filteredOffers = [for (final (index, offer) in offers.indexed) index == offerIndex ? null : offer];
    return createCopyWithOffers(filteredOffers);
  }

  void _checkOfferIndex(int offerIndex) {
    if (offerIndex < 0 || offerIndex >= offers.length) {
      throw ShopOfferIndexOutOfRangeError(
        offerIndex: offerIndex,
        offerCount: offers.length,
      );
    }
  }
}
