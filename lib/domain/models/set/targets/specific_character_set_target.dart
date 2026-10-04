import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/set/set_effect_targeting.dart';
import 'package:going_wild/domain/models/set/set_target.dart';

class SpecificCharacterSetTarget extends SetTarget {
  const SpecificCharacterSetTarget({required this.character});

  final Character character;

  @override
  bool reaches(SetEffectTargeting targeting) => targeting.isOwnTeam && targeting.character == character;
}
