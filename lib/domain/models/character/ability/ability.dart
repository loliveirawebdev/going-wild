import 'ability_effect.dart';

class Ability {
  const Ability({required this.id, required this.effects});

  final String id;
  final List<AbilityEffect> effects;
}
