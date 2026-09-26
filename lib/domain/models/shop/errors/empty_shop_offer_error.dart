class EmptyShopOfferError extends StateError {
  EmptyShopOfferError({required int offerIndex}) : super('Shop offer $offerIndex is empty');
}
