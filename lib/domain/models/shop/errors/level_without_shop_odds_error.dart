class LevelWithoutShopOddsError extends StateError {
  LevelWithoutShopOddsError({required int levelNumber}) : super('Level $levelNumber has no shop odds');
}
