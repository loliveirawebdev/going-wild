import 'package:going_wild/domain/models/character/stats/errors/missing_stat_error.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';

class Stats {
  const Stats(this._values);
  final Map<Stat, double> _values;
  double operator [](Stat stat) => _values[stat] ?? (throw MissingStatError(stat: stat));
  Stats createCopyWithStat(Stat stat, double value) => Stats({..._values, stat: value});
}
