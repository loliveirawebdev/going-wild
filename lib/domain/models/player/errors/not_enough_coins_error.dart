class NotEnoughCoinsError extends StateError {
  NotEnoughCoinsError({required int costInCoins, required int coins}) : super('Cannot spend $costInCoins coins with only $coins coins');
}
