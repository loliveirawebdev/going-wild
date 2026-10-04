import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/stats/stats.dart';

abstract class CharacterEngine {
  const CharacterEngine();

  int get maxStars;
  Stats statsAtStars(Character character, {required int stars});
}
