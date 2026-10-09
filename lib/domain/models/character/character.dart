import 'package:going_wild/domain/models/character/abilities/ability.dart';
import 'package:going_wild/domain/models/character/character_id.dart';
import 'package:going_wild/domain/models/character/rarity.dart';
import 'package:going_wild/domain/models/character/role.dart';
import 'package:going_wild/domain/models/character/sprite/character_sprite.dart';
import 'package:going_wild/domain/models/character/stats/stat_multipliers.dart';

class Character {
  const Character({
    required this.id,
    required this.role,
    required this.rarity,
    required this.sprite,
    required this.ability,
    required this.statMultipliers,
  });

  final Role role;
  final Rarity rarity;
  final CharacterId id;
  final Ability ability;
  final CharacterSprite sprite;
  final StatMultipliers statMultipliers;
}
