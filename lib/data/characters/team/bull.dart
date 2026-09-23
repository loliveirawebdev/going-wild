import 'package:going_wild/domain/models/models.dart';

const Character bull = Character(
  id: 'bull',
  role: Role.tank,
  rarity: Rarity.epic,

  ability: Ability(
    id: 'charge',
    trigger: AbilityTrigger.manaFull,

    effects: [
      DamageEffect(
        target: EffectTarget.enemiesAroundFocus,
        value: StarValues(star1: 350, star2: 525, star3: 800),
      ),

      KnockbackEffect(
        target: EffectTarget.enemiesAroundFocus,
        cells: 2,
      ),

      StunEffect(
        target: EffectTarget.enemiesAroundFocus,
        seconds: StarValues(star1: 1.5, star2: 1.5, star3: 1.5),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 2.05,
    Stat.damage: 1.65,
    Stat.armor: 2.15,
    Stat.shield: 1,
    Stat.attackSpeed: 0.95,
    Stat.moveSpeed: 1.3,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 90,
    Stat.range: 1,
  }),
);
