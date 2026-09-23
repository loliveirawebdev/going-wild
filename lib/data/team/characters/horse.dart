import 'package:going_wild/domain/models/models.dart';

const Character horse = Character(
  id: 'horse',
  role: Role.damage,
  rarity: Rarity.rare,

  ability: Ability(
    id: 'gallop',

    effects: [
      DamageEffect(
        target: EffectTarget.line,
        value: StarValues(star1: 250, star2: 375, star3: 560),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 1.4,
    Stat.damage: 1.8,
    Stat.armor: 1.2,
    Stat.shield: 1,
    Stat.attackSpeed: 1.15,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 70,
    Stat.range: 1,
  }),
);
