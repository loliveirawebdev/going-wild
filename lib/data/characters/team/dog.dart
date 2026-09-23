import 'package:going_wild/domain/models/models.dart';

const Character dog = Character(
  id: 'dog',
  role: Role.guard,
  rarity: Rarity.uncommon,

  ability: Ability(
    id: 'bark',
    trigger: AbilityTrigger.manaFull,

    effects: [
      TauntEffect(
        target: EffectTarget.allEnemies,
        seconds: StarValues(star1: 2, star2: 2, star3: 2),
      ),

      StatBuffEffect(
        target: EffectTarget.self,
        stat: Stat.armor,
        changeType: StatChangeType.absoluteValue,
        value: StarValues(star1: 30, star2: 50, star3: 80),
        seconds: StarValues(star1: 2, star2: 2, star3: 2),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 1.45,
    Stat.damage: 1.2,
    Stat.armor: 1.9,
    Stat.shield: 1,
    Stat.attackSpeed: 1,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 20,
    Stat.manaMax: 70,
    Stat.range: 1,
  }),
);
