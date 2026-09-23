import 'package:going_wild/domain/models/models.dart';

const Character chicken = Character(
  id: 'chicken',
  role: Role.support,
  rarity: Rarity.common,
  range: AttackRange.midRange,
  mana: Mana(start: 0, max: 60),

  ability: Ability(
    id: 'brood',

    effects: [
      HealEffect(
        target: EffectTarget.nearbyAllies,
        valuePerSecond: StarValues(star1: 40, star2: 60, star3: 90),
        seconds: StarValues(star1: 3, star2: 3, star3: 3),
      ),
    ],
  ),

  baseStatMultipliers: BaseStatMultipliers(
    health: 1,
    damage: 1,
    armor: 1,
    shield: 1,
    attackSpeed: 1,
    damageTakenPercentage: 1,
  ),
);
