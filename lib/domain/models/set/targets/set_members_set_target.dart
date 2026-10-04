import 'package:going_wild/domain/models/set/set_effect_targeting.dart';
import 'package:going_wild/domain/models/set/set_target.dart';

class SetMembersSetTarget extends SetTarget {
  const SetMembersSetTarget();

  @override
  bool reaches(SetEffectTargeting targeting) => targeting.isOwnTeam && targeting.set.members.contains(targeting.character);
}
