import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/engines/character_engine.dart';
import 'package:going_wild/domain/models/character/role.dart';
import 'package:going_wild/domain/models/character/stars/merge_curve.dart';
import 'package:going_wild/domain/models/character/stars/star_values.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stats.dart';

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
