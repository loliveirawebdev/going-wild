import 'package:going_wild/domain/models/models.dart';

const Character fox = Character(
  id: 'fox',
  role: Role.damage,
  rarity: Rarity.common,

  ability: Ability(
    id: 'escape',
    trigger: AbilityTrigger.lowHealth,

    effects: [
      AmbushEffect(
        target: EffectTarget.lowestHealthEnemy,
        seconds: StarValues(star1: 1, star2: 1, star3: 1),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 0.8,
    Stat.damage: 1.1,
    Stat.armor: 0.6,
    Stat.shield: 1,
    Stat.attackSpeed: 1.2,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 40,
    Stat.range: 1,
  }),
);
