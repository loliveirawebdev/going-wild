import 'abilities/ability.dart';
import 'character_id.dart';
import 'rarity.dart';
import 'role.dart';
import 'stats/stat_multipliers.dart';

class Character {
  const Character({
    required this.id,
    required this.role,
    required this.rarity,
    required this.ability,
    required this.statMultipliers,
  });

  final Role role;
  final Rarity rarity;
  final CharacterId id;
  final Ability ability;
  final StatMultipliers statMultipliers;
}
