class ShopAlreadyUnlockedError extends StateError {
  ShopAlreadyUnlockedError() : super('The shop is already unlocked');
}
