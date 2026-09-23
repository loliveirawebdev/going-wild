import 'package:going_wild/domain/models/models.dart';

const Character bull = Character(
  id: 'bull',
  role: Role.tank,
  rarity: Rarity.epic,
  range: AttackRange.melee,
  mana: Mana(start: 0, max: 90),

  ability: Ability(
    id: 'charge',

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

  baseStatMultipliers: BaseStatMultipliers(
    health: 1.15,
    damage: 0.9,
    armor: 1.2,
    shield: 1,
    attackSpeed: 0.95,
    damageTakenPercentage: 1,
  ),
);
