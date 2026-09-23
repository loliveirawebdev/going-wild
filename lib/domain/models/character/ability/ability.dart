import 'ability_effect.dart';
import 'ability_trigger.dart';

class Ability {
  const Ability({required this.id, required this.trigger, required this.effects});

  final String id;
  final AbilityTrigger trigger;
  final List<AbilityEffect> effects;
}
