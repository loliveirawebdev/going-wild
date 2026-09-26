import 'package:going_wild/domain/models/character/engines/basic_character_engine.dart';

import '../../character/base_stats.dart';
import '../../character/merge_curves_per_role/merge_curves_per_role.dart';

const BasicCharacterEngine basicCharacterEngine = BasicCharacterEngine(
  baseStats: baseStats,
  mergeCurveForRole: mergeCurveForRole,
);
