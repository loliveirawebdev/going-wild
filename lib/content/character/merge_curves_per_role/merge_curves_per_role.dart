import 'package:going_wild/content/character/merge_curves_per_role/damage.dart';
import 'package:going_wild/content/character/merge_curves_per_role/guard.dart';
import 'package:going_wild/content/character/merge_curves_per_role/support.dart';
import 'package:going_wild/content/character/merge_curves_per_role/tank.dart';
import 'package:going_wild/domain/models/character/role.dart';
import 'package:going_wild/domain/models/character/stars/merge_curve.dart';

export 'damage.dart';
export 'guard.dart';
export 'support.dart';
export 'tank.dart';

MergeCurve mergeCurveForRole(Role role) => switch (role) {
  Role.tank => tankMergeCurve,
  Role.guard => guardMergeCurve,
  Role.damage => damageMergeCurve,
  Role.support => supportMergeCurve,
};
