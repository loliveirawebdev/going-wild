import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stat_change_type.dart';

class StatModification {
  const StatModification({required this.stat, required this.value, required this.changeType});

  final Stat stat;
  final double value;
  final StatChangeType changeType;

  @override
  bool operator ==(Object other) =>
      other is StatModification && other.stat == stat && other.value == value && other.changeType == changeType;

  @override
  int get hashCode => Object.hash(stat, value, changeType);
}

double applyStatModifications(double baseValue, Iterable<StatModification> statModifications) {
  final multipliers = statModifications.where((statModification) => statModification.changeType == StatChangeType.multiplier);
  final additions = statModifications.where((statModification) => statModification.changeType == StatChangeType.absoluteValue);

  var modifiedValue = baseValue;
  for (final multiplier in multipliers) modifiedValue *= multiplier.value;
  for (final addition in additions) modifiedValue += addition.value;

  return modifiedValue;
}
