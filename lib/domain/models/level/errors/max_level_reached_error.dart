class MaxLevelReachedError extends StateError {
  MaxLevelReachedError({required int maxLevel}) : super('Level $maxLevel is the max level and has no next level');
}
