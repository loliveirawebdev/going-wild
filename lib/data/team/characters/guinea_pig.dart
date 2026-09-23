import 'package:going_wild/domain/models/models.dart';

const Character guineaPig = Character(
  id: 'guinea_pig',
  role: Role.guard,
  rarity: Rarity.common,

  ability: Ability(
    id: 'shriek',

    effects: [
      StunEffect(
        target: EffectTarget.focus,
        seconds: StarValues(star1: 1, star2: 1.5, star3: 2.5),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 0.9,
    Stat.damage: 0.9,
    Stat.armor: 1,
    Stat.shield: 1,
    Stat.attackSpeed: 1,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 50,
    Stat.range: 2,
  }),
);
