import 'package:going_wild/domain/models/models.dart';

const MergeCurve damageMergeCurve = MergeCurve({
  Stat.health: StarValues(star1: 1, star2: 1.65, star3: 2.72),
  Stat.damage: StarValues(star1: 1, star2: 1.65, star3: 2.72),
  Stat.armor: StarValues(star1: 1, star2: 1, star3: 1),
  Stat.shield: StarValues(star1: 1, star2: 1, star3: 1),
  Stat.attackSpeed: StarValues(star1: 1, star2: 1, star3: 1),
  Stat.moveSpeed: StarValues(star1: 1, star2: 1.1, star3: 1.21),
  Stat.damageTakenPercentage: StarValues(star1: 1, star2: 1, star3: 1),
  Stat.manaStart: StarValues(star1: 1, star2: 1, star3: 1),
  Stat.manaMax: StarValues(star1: 1, star2: 1, star3: 1),
  Stat.range: StarValues(star1: 1, star2: 1, star3: 1),
});
