import '../base/stat_multipliers.dart';
import 'ability/ability.dart';
import 'rarity.dart';
import 'role.dart';

class Character {
  const Character({
    required this.id,
    required this.role,
    required this.rarity,
    required this.statMultipliers,
    required this.ability,
  });

  final String id;
  final Role role;
  final Rarity rarity;
  final StatMultipliers statMultipliers;
  final Ability ability;
}
