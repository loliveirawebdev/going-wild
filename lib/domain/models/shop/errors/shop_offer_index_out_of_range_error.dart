class ShopOfferIndexOutOfRangeError extends StateError {
  ShopOfferIndexOutOfRangeError({required int offerIndex, required int offerCount})
    : super('Offer $offerIndex is outside a shop of $offerCount offers');
}
