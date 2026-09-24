import 'package:going_wild/domain/models/models.dart';

const Character cat = Character(
  id: 'cat',
  role: Role.damage,
  rarity: Rarity.uncommon,

  ability: Ability(
    id: 'pounce',
    trigger: AbilityTrigger.manaFull,

    effects: [
      DamageEffect(
        target: EffectTarget.lowestHealthEnemy,
        value: StarValues(star1: 200, star2: 300, star3: 450),
      ),

      ManaRefundOnKillEffect(
        percentage: 50,
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 1.1,
    Stat.damage: 1.55,
    Stat.armor: 0.9,
    Stat.shield: 1,
    Stat.attackSpeed: 1.2,
    Stat.moveSpeed: 1.6,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 60,
    Stat.range: 1,
  }),
);
