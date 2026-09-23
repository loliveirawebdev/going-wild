import 'package:going_wild/domain/models/models.dart';

const Character rat = Character(
  id: 'rat',
  role: Role.damage,
  rarity: Rarity.common,

  ability: Ability(
    id: 'bite',
    trigger: AbilityTrigger.manaFull,

    effects: [
      NextHitsStatBuffEffect(
        target: EffectTarget.self,
        stat: Stat.damage,
        changeType: StatChangeType.absoluteValue,
        value: StarValues(star1: 15, star2: 25, star3: 40),
        hits: 1,
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 0.35,
    Stat.damage: 0.5,
    Stat.armor: 0.5,
    Stat.shield: 1,
    Stat.attackSpeed: 1.2,
    Stat.moveSpeed: 1.2,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 30,
    Stat.range: 1,
  }),
);
