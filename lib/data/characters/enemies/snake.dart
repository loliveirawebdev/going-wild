import 'package:going_wild/domain/models/models.dart';

const Character snake = Character(
  id: 'snake',
  role: Role.damage,
  rarity: Rarity.uncommon,

  ability: Ability(
    id: 'venom',
    trigger: AbilityTrigger.manaFull,

    effects: [
      DamageOverTimeEffect(
        target: EffectTarget.focus,
        damagePerSecond: StarValues(star1: 30, star2: 45, star3: 70),
        seconds: StarValues(star1: 4, star2: 4, star3: 4),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 0.9,
    Stat.damage: 1,
    Stat.armor: 0.8,
    Stat.shield: 1,
    Stat.attackSpeed: 1,
    Stat.moveSpeed: 0.7,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 20,
    Stat.manaMax: 50,
    Stat.range: 1,
  }),
);
