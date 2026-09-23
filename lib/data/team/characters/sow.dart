import 'package:going_wild/domain/models/models.dart';

const Character sow = Character(
  id: 'sow',
  role: Role.support,
  rarity: Rarity.uncommon,
  range: AttackRange.melee,
  mana: Mana(start: 0, max: 70),

  ability: Ability(
    id: 'mud-roll',

    effects: [
      StatDebuffEffect(
        target: EffectTarget.nearbyEnemies,
        stat: Stat.attackSpeed,
        changeType: StatChangeType.multiplier,
        value: StarValues(star1: 0.6, star2: 0.6, star3: 0.6),
        seconds: StarValues(star1: 2, star2: 3, star3: 4),
      ),

      DamageEffect(
        target: EffectTarget.nearbyEnemies,
        value: StarValues(star1: 80, star2: 120, star3: 180),
      ),
    ],
  ),

  baseStatMultipliers: BaseStatMultipliers(
    health: 1.15,
    damage: 0.9,
    armor: 1.3,
    shield: 1,
    attackSpeed: 0.95,
    damageTakenPercentage: 1,
  ),
);
