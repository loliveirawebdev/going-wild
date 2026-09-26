class TeamIsFullError extends StateError {
  TeamIsFullError({required int limit}) : super('The team already has $limit characters on the board');
}
