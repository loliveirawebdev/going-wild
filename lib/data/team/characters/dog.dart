import 'package:going_wild/domain/models/models.dart';

const Character dog = Character(
  id: 'dog',
  role: Role.guard,
  rarity: Rarity.uncommon,
  range: AttackRange.melee,
  mana: Mana(start: 20, max: 70),

  ability: Ability(
    id: 'bark',

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

  baseStatMultipliers: BaseStatMultipliers(
    health: 1.2,
    damage: 1,
    armor: 1.5,
    shield: 1,
    attackSpeed: 1,
    damageTakenPercentage: 1,
  ),
);
