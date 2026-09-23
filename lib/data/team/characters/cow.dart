import 'package:going_wild/domain/models/models.dart';

const Character cow = Character(
  id: 'cow',
  role: Role.tank,
  rarity: Rarity.rare,

  ability: Ability(
    id: 'moo',

    effects: [
      ShieldEffect(
        target: EffectTarget.self,
        value: StarValues(star1: 300, star2: 450, star3: 675),
        seconds: StarValues(star1: 4, star2: 4, star3: 4),
        onExpire: [
          DamageEffect(
            target: EffectTarget.nearbyEnemies,
            value: StarValues(star1: 150, star2: 225, star3: 340),
          ),
        ],
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 1.9,
    Stat.damage: 1.1,
    Stat.armor: 2.3,
    Stat.shield: 1,
    Stat.attackSpeed: 0.85,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 80,
    Stat.range: 1,
  }),
);
