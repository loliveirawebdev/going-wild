import 'package:going_wild/domain/models/models.dart';

const Character queenBee = Character(
  id: 'queen-bee',
  role: Role.support,
  rarity: Rarity.rare,
  range: AttackRange.longRange,
  mana: Mana(start: 0, max: 60),

  ability: Ability(
    id: 'swarm',

    effects: [
      DamageOverTimeEffect(
        target: EffectTarget.enemiesAroundFocus,
        valuePerSecond: StarValues(star1: 60, star2: 90, star3: 135),
        seconds: StarValues(star1: 4, star2: 4, star3: 4),
      ),
    ],
  ),

  baseStatMultipliers: BaseStatMultipliers(
    health: 0.9,
    damage: 0.85,
    armor: 0.7,
    shield: 1,
    attackSpeed: 1.15,
    damageTakenPercentage: 1,
  ),
);
