import 'package:going_wild/domain/models/character/errors/invalid_stars_error.dart';

class StarValues {
  const StarValues({required this.star1, required this.star2, required this.star3});

  static const int maxStars = 3;

  final double star1;
  final double star2;
  final double star3;

  double at(int stars) => switch (stars) {
    1 => star1,
    2 => star2,
    3 => star3,
    _ => throw InvalidStarsError(stars: stars, maxStars: maxStars),
  };
}
