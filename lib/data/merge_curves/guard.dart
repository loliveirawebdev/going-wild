import 'package:going_wild/domain/models/models.dart';

const MergeCurve guardMergeCurve = MergeCurve({
  Stat.health: StarValues(star1: 1, star2: 1.8, star3: 3.24),
  Stat.damage: StarValues(star1: 1, star2: 1.45, star3: 2.1),
  Stat.armor: StarValues(star1: 1, star2: 1.2, star3: 1.44),
  Stat.shield: StarValues(star1: 1, star2: 1, star3: 1),
  Stat.attackSpeed: StarValues(star1: 1, star2: 1, star3: 1),
  Stat.moveSpeed: StarValues(star1: 1, star2: 1.1, star3: 1.21),
  Stat.damageTakenPercentage: StarValues(star1: 1, star2: 1, star3: 1),
  Stat.manaStart: StarValues(star1: 1, star2: 1, star3: 1),
  Stat.manaMax: StarValues(star1: 1, star2: 1, star3: 1),
  Stat.range: StarValues(star1: 1, star2: 1, star3: 1),
});
