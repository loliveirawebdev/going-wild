import 'package:going_wild/domain/models/models.dart';

const Character sheep = Character(
  id: 'sheep',
  role: Role.support,
  rarity: Rarity.uncommon,
  range: AttackRange.melee,
  mana: Mana(start: 30, max: 80),

  ability: Ability(
    id: 'wool-cloak',

    effects: [
      ShieldEffect(
        target: EffectTarget.lowestHealthAlly,
        value: StarValues(star1: 200, star2: 300, star3: 450),
        seconds: StarValues(star1: 4, star2: 4, star3: 4),
      ),
    ],
  ),

  baseStatMultipliers: BaseStatMultipliers(
    health: 1.1,
    damage: 0.8,
    armor: 1.1,
    shield: 1,
    attackSpeed: 0.95,
    damageTakenPercentage: 1,
  ),
);
