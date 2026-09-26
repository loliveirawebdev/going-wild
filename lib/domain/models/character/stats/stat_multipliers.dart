import 'stat.dart';

class StatMultipliers {
  const StatMultipliers(this._values);
  final Map<Stat, double> _values;

  Set<Stat> get definedStats => _values.keys.toSet();
  double operator [](Stat stat) => _values[stat] ?? 1;
}
