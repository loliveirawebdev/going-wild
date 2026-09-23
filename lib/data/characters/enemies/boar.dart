import 'package:going_wild/domain/models/models.dart';

const Character boar = Character(
  id: 'boar',
  role: Role.tank,
  rarity: Rarity.uncommon,

  ability: Ability(
    id: 'charge',
    trigger: AbilityTrigger.manaFull,

    effects: [
      KnockbackEffect(
        target: EffectTarget.focus,
        cells: 1,
      ),

      StunEffect(
        target: EffectTarget.focus,
        seconds: StarValues(star1: 1, star2: 1.5, star3: 2),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 1.6,
    Stat.damage: 0.9,
    Stat.armor: 1.5,
    Stat.shield: 1,
    Stat.attackSpeed: 0.7,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 70,
    Stat.range: 1,
  }),
);
