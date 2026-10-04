import 'package:going_wild/domain/models/set/set_effect_targeting.dart';
import 'package:going_wild/domain/models/set/set_target.dart';

class EntireTeamSetTarget extends SetTarget {
  const EntireTeamSetTarget();

  @override
  bool reaches(SetEffectTargeting targeting) => targeting.isOwnTeam;
}
