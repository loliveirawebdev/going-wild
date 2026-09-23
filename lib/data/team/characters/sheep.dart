import 'package:going_wild/domain/models/models.dart';

const Character sheep = Character(
  id: 'sheep',
  role: Role.support,
  rarity: Rarity.uncommon,

  ability: Ability(
    id: 'wool_cloak',

    effects: [
      ShieldEffect(
        target: EffectTarget.lowestHealthAlly,
        value: StarValues(star1: 200, star2: 300, star3: 450),
        seconds: StarValues(star1: 4, star2: 4, star3: 4),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 1.3,
    Stat.damage: 0.95,
    Stat.armor: 1.4,
    Stat.shield: 1,
    Stat.attackSpeed: 0.95,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 30,
    Stat.manaMax: 80,
    Stat.range: 1,
  }),
);
