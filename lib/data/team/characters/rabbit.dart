import 'package:going_wild/domain/models/models.dart';

const Character rabbit = Character(
  id: 'rabbit',
  role: Role.damage,
  rarity: Rarity.common,
  range: AttackRange.midRange,
  mana: Mana(start: 0, max: 40),

  ability: Ability(
    id: 'quick-paws',

    effects: [
      NextHitsStatBuffEffect(
        target: EffectTarget.self,
        stat: Stat.attackSpeed,
        changeType: StatChangeType.multiplier,
        value: StarValues(star1: 2, star2: 2, star3: 2),
        hits: 3,
      ),

      NextHitsStatBuffEffect(
        target: EffectTarget.self,
        stat: Stat.damage,
        changeType: StatChangeType.absoluteValue,
        value: StarValues(star1: 30, star2: 45, star3: 70),
        hits: 3,
      ),
    ],
  ),

  baseStatMultipliers: BaseStatMultipliers(
    health: 0.95,
    damage: 1.05,
    armor: 0.75,
    shield: 1,
    attackSpeed: 1.2,
    damageTakenPercentage: 1,
  ),
);
