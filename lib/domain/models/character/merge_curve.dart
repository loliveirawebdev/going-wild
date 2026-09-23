import '../base/star_values.dart';
import '../base/stat.dart';

class MergeCurve {
  const MergeCurve(this._multipliers);
  final Map<Stat, StarValues> _multipliers;
  static const StarValues _unscaled = StarValues(star1: 1, star2: 1, star3: 1);
  StarValues operator [](Stat stat) => _multipliers[stat] ?? _unscaled;

  bool defines(Stat stat) => _multipliers.containsKey(stat);
}
