import 'package:going_wild/domain/models/models.dart';

const Character goat = Character(
  id: 'goat',
  role: Role.tank,
  rarity: Rarity.uncommon,
  range: AttackRange.melee,
  mana: Mana(start: 0, max: 60),

  ability: Ability(
    id: 'headbutt',

    effects: [
      KnockbackEffect(
        target: EffectTarget.focus,
        cells: 1,
      ),

      DamageEffect(
        target: EffectTarget.focus,
        value: StarValues(star1: 150, star2: 225, star3: 340),
      ),
    ],
  ),

  baseStatMultipliers: BaseStatMultipliers(
    health: 1.25,
    damage: 0.9,
    armor: 1.65,
    shield: 1,
    attackSpeed: 0.95,
    damageTakenPercentage: 1,
  ),
);
