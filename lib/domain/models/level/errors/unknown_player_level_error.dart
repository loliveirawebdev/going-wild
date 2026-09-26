class UnknownPlayerLevelError extends StateError {
  UnknownPlayerLevelError({required int levelNumber}) : super('Level $levelNumber is not one of the configured player levels');
}
