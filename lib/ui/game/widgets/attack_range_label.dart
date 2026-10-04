import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';

double attackRangeOf(MatchProgress matchProgress, Character character) {
  final stats = matchProgress.phase.engines.characterEngine.statsAtStars(character, stars: 1);
  return stats[Stat.range];
}

String attackRangeLabelOf(Translations translations, double attackRange) {
  final isMelee = attackRange <= 1;
  if (isMelee) return translations.game.melee;

  return translations.game.ranged(range: attackRange.round());
}
