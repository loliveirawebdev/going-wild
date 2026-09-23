import 'package:going_wild/domain/models/models.dart';

const Character queenBee = Character(
  id: 'queen_bee',
  role: Role.support,
  rarity: Rarity.rare,

  ability: Ability(
    id: 'swarm',
    trigger: AbilityTrigger.manaFull,

    effects: [
      DamageOverTimeEffect(
        target: EffectTarget.enemiesAroundFocus,
        valuePerSecond: StarValues(star1: 60, star2: 90, star3: 135),
        seconds: StarValues(star1: 4, star2: 4, star3: 4),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 1.3,
    Stat.damage: 1.2,
    Stat.armor: 1.05,
    Stat.shield: 1,
    Stat.attackSpeed: 1.15,
    Stat.moveSpeed: 1.4,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 60,
    Stat.range: 4,
  }),
);
