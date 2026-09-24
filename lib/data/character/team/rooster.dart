import 'package:going_wild/domain/models/models.dart';

const Character rooster = Character(
  id: 'rooster',
  role: Role.damage,
  rarity: Rarity.common,

  ability: Ability(
    id: 'dawn_call',
    trigger: AbilityTrigger.manaFull,

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

  statMultipliers: StatMultipliers({
    Stat.health: 0.85,
    Stat.damage: 1.3,
    Stat.armor: 0.5,
    Stat.shield: 1,
    Stat.attackSpeed: 1.15,
    Stat.moveSpeed: 0.8,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 50,
    Stat.range: 2,
  }),
);
