import 'package:going_wild/domain/models/models.dart';

const Character cerberus = Character(
  id: 'cerberus',
  role: Role.tank,
  rarity: Rarity.epic,

  ability: Ability(
    id: 'three_heads',
    trigger: AbilityTrigger.manaFull,

    effects: [
      DamageEffect(
        target: EffectTarget.enemiesAroundFocus,
        value: StarValues(star1: 220, star2: 330, star3: 500),
      ),

      StatBuffEffect(
        target: EffectTarget.self,
        stat: Stat.attackSpeed,
        changeType: StatChangeType.multiplier,
        value: StarValues(star1: 1.4, star2: 1.6, star3: 1.8),
        seconds: StarValues(star1: 4, star2: 4, star3: 4),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 3.5,
    Stat.damage: 1.6,
    Stat.armor: 2.4,
    Stat.shield: 1,
    Stat.attackSpeed: 0.8,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 80,
    Stat.range: 1,
  }),
);
