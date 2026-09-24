import 'package:going_wild/domain/models/models.dart';

const Character sow = Character(
  id: 'sow',
  role: Role.support,
  rarity: Rarity.uncommon,

  ability: Ability(
    id: 'mud_roll',
    trigger: AbilityTrigger.manaFull,

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

  statMultipliers: StatMultipliers({
    Stat.health: 1.4,
    Stat.damage: 1.1,
    Stat.armor: 1.6,
    Stat.shield: 1,
    Stat.attackSpeed: 0.95,
    Stat.moveSpeed: 1,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 70,
    Stat.range: 1,
  }),
);
