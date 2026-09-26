import 'package:going_wild/domain/models/character/role.dart';
import 'package:going_wild/domain/models/character/stars/merge_curve.dart';

import 'damage.dart';
import 'guard.dart';
import 'support.dart';
import 'tank.dart';

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
