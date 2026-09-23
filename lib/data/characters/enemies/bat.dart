import 'package:going_wild/domain/models/models.dart';

const Character bat = Character(
  id: 'bat',
  role: Role.damage,
  rarity: Rarity.uncommon,

  ability: Ability(
    id: 'blood',
    trigger: AbilityTrigger.manaFull,

    effects: [
      LifestealEffect(
        target: EffectTarget.focus,
        value: StarValues(star1: 120, star2: 180, star3: 270),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 0.6,
    Stat.damage: 0.9,
    Stat.armor: 0.4,
    Stat.shield: 1,
    Stat.attackSpeed: 1.1,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 50,
    Stat.range: 2,
  }),
);
