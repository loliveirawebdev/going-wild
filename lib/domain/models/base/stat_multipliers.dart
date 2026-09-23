import 'stat.dart';

class StatMultipliers {
  const StatMultipliers(this._values);
  final Map<Stat, double> _values;
  double operator [](Stat stat) => _values[stat] ?? 1;

  bool defines(Stat stat) => _values.containsKey(stat);
}
