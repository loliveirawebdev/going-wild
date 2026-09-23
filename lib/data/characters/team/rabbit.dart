import 'package:going_wild/domain/models/models.dart';

const Character rabbit = Character(
  id: 'rabbit',
  role: Role.damage,
  rarity: Rarity.common,

  ability: Ability(
    id: 'quick_paws',
    trigger: AbilityTrigger.manaFull,

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

  statMultipliers: StatMultipliers({
    Stat.health: 0.95,
    Stat.damage: 1.05,
    Stat.armor: 0.75,
    Stat.shield: 1,
    Stat.attackSpeed: 1.2,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 40,
    Stat.range: 2,
  }),
);
