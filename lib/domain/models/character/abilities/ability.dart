import 'package:going_wild/domain/models/character/abilities/ability_effect.dart';
import 'package:going_wild/domain/models/character/abilities/ability_trigger.dart';

class Ability {
  const Ability({required this.trigger, required this.effects});

  final AbilityTrigger trigger;
  final List<AbilityEffect> effects;
}
