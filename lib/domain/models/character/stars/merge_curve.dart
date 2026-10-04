import 'package:going_wild/domain/models/character/stars/star_values.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';

class MergeCurve {
  const MergeCurve(this._multipliers);
  final Map<Stat, StarValues> _multipliers;
  static const StarValues _unscaled = StarValues(star1: 1, star2: 1, star3: 1);

  Set<Stat> get definedStats => _multipliers.keys.toSet();
  StarValues operator [](Stat stat) => _multipliers[stat] ?? _unscaled;
}
