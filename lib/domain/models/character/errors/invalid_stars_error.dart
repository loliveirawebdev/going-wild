class InvalidStarsError extends StateError {
  InvalidStarsError({required int stars, required int maxStars}) : super('$stars stars is outside 1 to $maxStars');
}
