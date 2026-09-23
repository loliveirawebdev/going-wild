part of '../ability_effect.dart';

class StatBuffEffect extends AbilityEffect {
  const StatBuffEffect({
    required this.target,
    required this.stat,
    required this.changeType,
    required this.value,
    required this.seconds,
  });

  final EffectTarget target;
  final Stat stat;
  final StatChangeType changeType;
  final StarValues value;
  final StarValues seconds;
}
