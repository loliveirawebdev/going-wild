class PlayerHasNoLivesLeftError extends StateError {
  PlayerHasNoLivesLeftError() : super('The player has no lives left to lose');
}
