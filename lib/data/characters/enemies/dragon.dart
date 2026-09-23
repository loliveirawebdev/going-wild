import 'package:going_wild/domain/models/models.dart';

const Character dragon = Character(
  id: 'dragon',
  role: Role.damage,
  rarity: Rarity.epic,

  ability: Ability(
    id: 'fire_breath',
    trigger: AbilityTrigger.manaFull,

    effects: [
      DamageEffect(
        target: EffectTarget.enemiesAroundFocus,
        value: StarValues(star1: 400, star2: 600, star3: 900),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 4.5,
    Stat.damage: 2,
    Stat.armor: 2.5,
    Stat.shield: 1,
    Stat.attackSpeed: 0.7,
    Stat.moveSpeed: 1.2,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 90,
    Stat.range: 4,
  }),
);
