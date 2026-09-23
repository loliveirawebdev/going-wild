import 'package:going_wild/domain/models/models.dart';

const Character acromantula = Character(
  id: 'acromantula',
  role: Role.guard,
  rarity: Rarity.epic,

  ability: Ability(
    id: 'web_burst',
    trigger: AbilityTrigger.manaFull,

    effects: [
      DamageEffect(
        target: EffectTarget.enemiesAroundFocus,
        value: StarValues(star1: 600, star2: 900, star3: 1350),
      ),
    ],
  ),

  statMultipliers: StatMultipliers({
    Stat.health: 2.8,
    Stat.damage: 1.2,
    Stat.armor: 1.8,
    Stat.shield: 1,
    Stat.attackSpeed: 0.8,
    Stat.damageTakenPercentage: 1,
    Stat.manaStart: 0,
    Stat.manaMax: 150,
    Stat.range: 2,
  }),
);
