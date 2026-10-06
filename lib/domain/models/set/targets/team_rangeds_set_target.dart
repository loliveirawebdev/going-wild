import 'package:going_wild/domain/models/set/set_effect_targeting.dart';
import 'package:going_wild/domain/models/set/set_target.dart';

class TeamRangedsSetTarget extends SetTarget {
  const TeamRangedsSetTarget();

  @override
  bool reaches(SetEffectTargeting targeting) => targeting.isOwnTeam && targeting.stats.isRanged;
}
