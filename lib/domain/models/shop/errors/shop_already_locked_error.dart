class ShopAlreadyLockedError extends StateError {
  ShopAlreadyLockedError() : super('The shop is already locked');
}
