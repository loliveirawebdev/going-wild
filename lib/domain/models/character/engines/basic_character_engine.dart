import '../character.dart';
import '../role.dart';
import '../stars/merge_curve.dart';
import '../stars/star_values.dart';
import '../stats/stat.dart';
import '../stats/stats.dart';
import 'character_engine.dart';

class BasicCharacterEngine extends CharacterEngine {
  const BasicCharacterEngine({required this.baseStats, required this.mergeCurveForRole});

  final Stats baseStats;
  final MergeCurve Function(Role role) mergeCurveForRole;

  @override
  int get maxStars => StarValues.maxStars;

  @override
  Stats statsAtStars(Character character, {required int stars}) {
    final mergeCurve = mergeCurveForRole(character.role);
    return Stats({for (final stat in Stat.values) stat: baseStats[stat] * character.statMultipliers[stat] * mergeCurve[stat].at(stars)});
  }
}
