import 'package:going_wild/domain/models/models.dart';

const Character cat = Character(
  id: 'cat',
  role: Role.damage,
  rarity: Rarity.uncommon,
  range: AttackRange.melee,
  mana: Mana(start: 0, max: 60),

  ability: Ability(
    id: 'pounce',

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

  baseStatMultipliers: BaseStatMultipliers(
    health: 0.9,
    damage: 1.3,
    armor: 0.7,
    shield: 1,
    attackSpeed: 1.2,
    damageTakenPercentage: 1,
  ),
);
