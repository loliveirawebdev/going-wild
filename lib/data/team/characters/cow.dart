import 'package:going_wild/domain/models/models.dart';

const Character cow = Character(
  id: 'cow',
  role: Role.tank,
  rarity: Rarity.rare,
  range: AttackRange.melee,
  mana: Mana(start: 0, max: 80),

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

  baseStatMultipliers: BaseStatMultipliers(
    health: 1.3,
    damage: 0.8,
    armor: 1.55,
    shield: 1,
    attackSpeed: 0.85,
    damageTakenPercentage: 1,
  ),
);
