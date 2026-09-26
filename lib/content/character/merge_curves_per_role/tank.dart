import 'package:going_wild/domain/models/character/stars/merge_curve.dart';
import 'package:going_wild/domain/models/character/stars/star_values.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';

const MergeCurve tankMergeCurve = MergeCurve({
  Stat.health: StarValues(star1: 1, star2: 1.9, star3: 3.61),
  Stat.damage: StarValues(star1: 1, star2: 1.4, star3: 1.96),
  Stat.armor: StarValues(star1: 1, star2: 1.15, star3: 1.32),
  Stat.attackSpeed: StarValues(star1: 1, star2: 1, star3: 1),
  Stat.moveSpeed: StarValues(star1: 1, star2: 1.1, star3: 1.21),
  Stat.damageTakenPercentage: StarValues(star1: 1, star2: 1, star3: 1),
  Stat.manaStart: StarValues(star1: 1, star2: 1, star3: 1),
  Stat.manaMax: StarValues(star1: 1, star2: 1, star3: 1),
  Stat.range: StarValues(star1: 1, star2: 1, star3: 1),
});
