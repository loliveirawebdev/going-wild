import 'ability_effect.dart';
import 'ability_trigger.dart';

class Ability {
  const Ability({required this.trigger, required this.effects});

  final AbilityTrigger trigger;
  final List<AbilityEffect> effects;
}
