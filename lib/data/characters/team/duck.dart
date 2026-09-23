import 'package:going_wild/domain/models/models.dart';

const Character duck = Character(
  id: 'duck',
  role: Role.damage,
  rarity: Rarity.common,

  ability: Ability(
    id: 'sharp_feathers',
    trigger: AbilityTrigger.manaFull,

    effects: [
      DamageEffect(
        target: EffectTarget.enemiesAroundFocus,
        value: StarValues(star1: 130, star2: 195, star3: 290),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 0.9,
    Stat.damage: 1.2,
    Stat.armor: 0.75,
    Stat.shield: 1,
    Stat.attackSpeed: 1.05,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 60,
    Stat.range: 2,
  }),
);
