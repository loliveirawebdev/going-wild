class StarValues {
  const StarValues({required this.star1, required this.star2, required this.star3});

  final double star1;
  final double star2;
  final double star3;

  double at(int stars) => switch (stars) {
    1 => star1,
    2 => star2,
    3 => star3,
    _ => throw ArgumentError.value(stars, 'stars', 'must be 1, 2 or 3'),
  };
}
