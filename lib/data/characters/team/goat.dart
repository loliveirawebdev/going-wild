import 'package:going_wild/domain/models/models.dart';

const Character goat = Character(
  id: 'goat',
  role: Role.tank,
  rarity: Rarity.uncommon,

  ability: Ability(
    id: 'headbutt',
    trigger: AbilityTrigger.manaFull,

    effects: [
      KnockbackEffect(
        target: EffectTarget.focus,
        cells: 1,
      ),

      DamageEffect(
        target: EffectTarget.focus,
        value: StarValues(star1: 150, star2: 225, star3: 340),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 1.5,
    Stat.damage: 1.1,
    Stat.armor: 2.05,
    Stat.shield: 1,
    Stat.attackSpeed: 0.95,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 60,
    Stat.range: 1,
  }),
);
