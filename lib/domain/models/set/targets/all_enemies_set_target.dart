import 'package:going_wild/domain/models/set/set_effect_targeting.dart';
import 'package:going_wild/domain/models/set/set_target.dart';

class AllEnemiesSetTarget extends SetTarget {
  const AllEnemiesSetTarget();

  @override
  bool get reachesEnemies => true;

  @override
  bool reaches(SetEffectTargeting targeting) => !targeting.isOwnTeam;
}
