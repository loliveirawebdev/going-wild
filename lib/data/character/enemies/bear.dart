import 'package:going_wild/domain/models/models.dart';

const Character bear = Character(
  id: 'bear',
  role: Role.tank,
  rarity: Rarity.rare,

  ability: Ability(
    id: 'slam',
    trigger: AbilityTrigger.manaFull,

    effects: [
      DamageEffect(
        target: EffectTarget.enemiesAroundFocus,
        value: StarValues(star1: 250, star2: 375, star3: 560),
      ),

      KnockbackEffect(
        target: EffectTarget.enemiesAroundFocus,
        cells: 1,
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 3,
    Stat.damage: 1.4,
    Stat.armor: 2.2,
    Stat.shield: 1,
    Stat.attackSpeed: 0.6,
    Stat.moveSpeed: 1.1,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 90,
    Stat.range: 1,
  }),
);
