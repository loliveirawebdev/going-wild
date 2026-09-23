import 'package:going_wild/domain/models/models.dart';

const Character alligator = Character(
  id: 'alligator',
  role: Role.tank,
  rarity: Rarity.rare,

  ability: Ability(
    id: 'bite_down',
    trigger: AbilityTrigger.manaFull,

    effects: [
      DamageEffect(
        target: EffectTarget.focus,
        value: StarValues(star1: 200, star2: 300, star3: 450),
      ),

      StunEffect(
        target: EffectTarget.focus,
        seconds: StarValues(star1: 1.5, star2: 2, star3: 2.5),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 2,
    Stat.damage: 1,
    Stat.armor: 2,
    Stat.shield: 1,
    Stat.attackSpeed: 0.6,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 80,
    Stat.range: 1,
  }),
);
