import 'package:going_wild/domain/models/models.dart';

const Character guineaPig = Character(
  id: 'guinea-pig',
  role: Role.guard,
  rarity: Rarity.common,
  range: AttackRange.midRange,
  mana: Mana(start: 0, max: 50),

  ability: Ability(
    id: 'shriek',

    effects: [
      StunEffect(
        target: EffectTarget.focus,
        seconds: StarValues(star1: 1, star2: 1.5, star3: 2.5),
      ),
    ],
  ),

  baseStatMultipliers: BaseStatMultipliers(
    health: 0.9,
    damage: 0.9,
    armor: 1,
    shield: 1,
    attackSpeed: 1,
    damageTakenPercentage: 1,
  ),
);
