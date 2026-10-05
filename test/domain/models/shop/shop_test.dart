import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/domain/models/shop/errors/shop_offer_index_out_of_range_error.dart';
import 'package:going_wild/domain/models/shop/shop.dart';

void main() {
  const shop = Shop(isLocked: false, offers: [cat, dog, null, cow]);

  test('locking and unlocking keep the offers', () {
    final lockedShop = shop.createCopyLocked();
    expect(lockedShop.isLocked, isTrue);
    expect(lockedShop.offers, shop.offers);

    final unlockedShop = lockedShop.createCopyUnlocked();
    expect(unlockedShop.isLocked, isFalse);
    expect(unlockedShop.offers, shop.offers);
  });

  test('taking an offer empties only that slot', () {
    expect(shop.createCopyWithoutOfferAt(1).offers, [cat, null, null, cow]);
  });

  test('new offers replace the old ones and keep the lock', () {
    final newShop = shop.createCopyLocked().createCopyWithOffers([sheep, goat, horse, bull]);
    expect(newShop.offers, [sheep, goat, horse, bull]);
    expect(newShop.isLocked, isTrue);
  });

  test('changing the shop never changes the original', () {
    shop.createCopyLocked().createCopyWithoutOfferAt(0);
    expect(shop.offers, [cat, dog, null, cow]);
    expect(shop.isLocked, isFalse);
  });

  test('an offer is read by its index', () {
    expect(shop.offerAt(1), dog);
    expect(shop.offerAt(2), isNull);
  });

  test('reading or taking an offer outside the shop fails', () {
    expect(() => shop.offerAt(4), throwsA(isA<ShopOfferIndexOutOfRangeError>()));
    expect(() => shop.createCopyWithoutOfferAt(-1), throwsA(isA<ShopOfferIndexOutOfRangeError>()));
  });

  test('taking an offer remembers who was sold there until new offers arrive', () {
    final shopAfterSale = shop.createCopyWithoutOfferAt(0);
    expect(shopAfterSale.offerAt(0), isNull);
    expect(shopAfterSale.soldOfferAt(0), cat);
    expect(shopAfterSale.soldOfferAt(1), isNull);
    expect(shopAfterSale.createCopyLocked().soldOfferAt(0), cat);

    expect(shopAfterSale.createCopyWithOffers([duck, goat]).soldOfferAt(0), isNull);
  });
}
