import 'package:going_wild/domain/models/models.dart';

const Character kraken = Character(
  id: 'kraken',
  role: Role.tank,
  rarity: Rarity.epic,

  ability: Ability(
    id: 'tentacles',
    trigger: AbilityTrigger.manaFull,

    effects: [
      PullEffect(
        target: EffectTarget.farthestEnemy,
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 4,
    Stat.damage: 1.5,
    Stat.armor: 2.2,
    Stat.shield: 1,
    Stat.attackSpeed: 0.9,
    Stat.moveSpeed: 0.4,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 20,
    Stat.manaMax: 70,
    Stat.range: 2,
  }),
);
