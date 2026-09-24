import 'package:going_wild/domain/models/models.dart';

const Character guineaPig = Character(
  id: 'guinea_pig',
  role: Role.guard,
  rarity: Rarity.common,

  ability: Ability(
    id: 'shriek',
    trigger: AbilityTrigger.manaFull,

    effects: [
      StunEffect(
        target: EffectTarget.enemiesAroundFocus,
        seconds: StarValues(star1: 1, star2: 1.5, star3: 2.5),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 1.2,
    Stat.damage: 1,
    Stat.armor: 1.3,
    Stat.shield: 1,
    Stat.attackSpeed: 1,
    Stat.moveSpeed: 0.8,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 50,
    Stat.range: 2,
  }),
);
