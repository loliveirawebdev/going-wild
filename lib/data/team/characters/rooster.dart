import 'package:going_wild/domain/models/models.dart';

const Character rooster = Character(
  id: 'rooster',
  role: Role.damage,
  rarity: Rarity.common,
  range: AttackRange.midRange,
  mana: Mana(start: 0, max: 50),

  ability: Ability(
    id: 'dawn-call',

    effects: [
      StatBuffEffect(
        target: EffectTarget.nearbyAllies,
        stat: Stat.attackSpeed,
        changeType: StatChangeType.multiplier,
        value: StarValues(star1: 1.25, star2: 1.4, star3: 1.6),
        seconds: StarValues(star1: 3, star2: 3, star3: 3),
      ),
    ],
  ),

  baseStatMultipliers: BaseStatMultipliers(
    health: 0.85,
    damage: 1.3,
    armor: 0.5,
    shield: 1,
    attackSpeed: 1.15,
    damageTakenPercentage: 1,
  ),
);
