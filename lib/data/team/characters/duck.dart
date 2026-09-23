import 'package:going_wild/domain/models/models.dart';

const Character duck = Character(
  id: 'duck',
  role: Role.damage,
  rarity: Rarity.common,
  range: AttackRange.midRange,
  mana: Mana(start: 0, max: 60),

  ability: Ability(
    id: 'sharp-feathers',

    effects: [
      DamageEffect(
        target: EffectTarget.enemiesAroundFocus,
        value: StarValues(star1: 130, star2: 195, star3: 290),
      ),
    ],
  ),

  baseStatMultipliers: BaseStatMultipliers(
    health: 0.9,
    damage: 1.2,
    armor: 0.75,
    shield: 1,
    attackSpeed: 1.05,
    damageTakenPercentage: 1,
  ),
);
