import 'package:going_wild/domain/models/models.dart';

const Character chicken = Character(
  id: 'chicken',
  role: Role.support,
  rarity: Rarity.common,

  ability: Ability(
    id: 'brood',
    trigger: AbilityTrigger.manaFull,

    effects: [
      HealEffect(
        target: EffectTarget.nearbyAllies,
        valuePerSecond: StarValues(star1: 40, star2: 60, star3: 90),
        seconds: StarValues(star1: 3, star2: 3, star3: 3),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 1,
    Stat.damage: 1,
    Stat.armor: 1,
    Stat.shield: 1,
    Stat.attackSpeed: 1,
    Stat.moveSpeed: 0.8,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 60,
    Stat.range: 2,
  }),
);
