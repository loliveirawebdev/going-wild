import 'ability/ability.dart';
import 'attack_range.dart';
import 'base_stat_multipliers.dart';
import 'mana.dart';
import 'rarity.dart';
import 'role.dart';

class Character {
  const Character({
    required this.id,
    required this.role,
    required this.rarity,
    required this.range,
    required this.baseStatMultipliers,
    required this.mana,
    required this.ability,
  });

  final String id;
  final Role role;
  final Rarity rarity;
  final AttackRange range;
  final BaseStatMultipliers baseStatMultipliers;
  final Mana mana;
  final Ability ability;

  bool get isMelee => range == AttackRange.melee;
}
