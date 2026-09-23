import 'package:going_wild/domain/models/models.dart';

import 'damage.dart';
import 'guard.dart';
import 'support.dart';
import 'tank.dart';

export 'damage.dart';
export 'guard.dart';
export 'support.dart';
export 'tank.dart';

MergeCurve mergeCurveFor(Role role) => switch (role) {
  Role.tank => tankMergeCurve,
  Role.damage => damageMergeCurve,
  Role.support => supportMergeCurve,
  Role.guard => guardMergeCurve,
};
