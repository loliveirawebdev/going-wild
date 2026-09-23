import 'package:going_wild/domain/models/models.dart';

const Character horse = Character(
  id: 'horse',
  role: Role.damage,
  rarity: Rarity.rare,
  range: AttackRange.melee,
  mana: Mana(start: 0, max: 70),

  ability: Ability(
    id: 'gallop',

    effects: [
      DamageEffect(
        target: EffectTarget.line,
        value: StarValues(star1: 250, star2: 375, star3: 560),
      ),
    ],
  ),

  baseStatMultipliers: BaseStatMultipliers(
    health: 0.95,
    damage: 1.3,
    armor: 0.8,
    shield: 1,
    attackSpeed: 1.15,
    damageTakenPercentage: 1,
  ),
);
