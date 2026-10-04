import 'package:going_wild/domain/models/set/set_effect_targeting.dart';

abstract class SetTarget {
  const SetTarget();

  bool get reachesEnemies => false;

  bool reaches(SetEffectTargeting targeting);
}
