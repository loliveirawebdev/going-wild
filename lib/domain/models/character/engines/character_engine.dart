import '../character.dart';
import '../stats/stats.dart';

abstract class CharacterEngine {
  const CharacterEngine();

  int get maxStars;
  Stats statsAtStars(Character character, {required int stars});
}
