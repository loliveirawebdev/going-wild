import 'package:going_wild/domain/models/models.dart';

const MergeCurve tankMergeCurve = MergeCurve({
  Stat.health: StarValues(star1: 1, star2: 1.9, star3: 3.61),
  Stat.damage: StarValues(star1: 1, star2: 1.4, star3: 1.96),
  Stat.armor: StarValues(star1: 1, star2: 1.15, star3: 1.32),
  Stat.shield: StarValues(star1: 1, star2: 1, star3: 1),
  Stat.attackSpeed: StarValues(star1: 1, star2: 1, star3: 1),
  Stat.damageTakenPercentage: StarValues(star1: 1, star2: 1, star3: 1),
  Stat.manaStart: StarValues(star1: 1, star2: 1, star3: 1),
  Stat.manaMax: StarValues(star1: 1, star2: 1, star3: 1),
  Stat.range: StarValues(star1: 1, star2: 1, star3: 1),
});
