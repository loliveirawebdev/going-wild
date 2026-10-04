import 'package:going_wild/domain/models/character/stats/stat_modification.dart';
import 'package:going_wild/domain/models/set/set_effect.dart';
import 'package:going_wild/domain/models/set/set_effect_targeting.dart';
import 'package:going_wild/domain/models/set/set_target.dart';

class SetStatModification extends SetEffect {
  const SetStatModification({required this.target, required this.statModification});

  @override
  final SetTarget target;

  final StatModification statModification;

  @override
  StatModification? statModificationFor(SetEffectTargeting targeting) => target.reaches(targeting) ? statModification : null;
}
