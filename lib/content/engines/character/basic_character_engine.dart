import 'package:going_wild/content/character/base_stats.dart';
import 'package:going_wild/content/character/merge_curves_per_role/merge_curves_per_role.dart';
import 'package:going_wild/domain/models/character/engines/basic_character_engine.dart';

const BasicCharacterEngine basicCharacterEngine = BasicCharacterEngine(
  baseStats: baseStats,
  mergeCurveForRole: mergeCurveForRole,
);
