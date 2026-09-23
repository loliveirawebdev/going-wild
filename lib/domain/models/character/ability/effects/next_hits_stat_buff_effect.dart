part of '../ability_effect.dart';

class NextHitsStatBuffEffect extends AbilityEffect {
  const NextHitsStatBuffEffect({
    required this.target,
    required this.stat,
    required this.changeType,
    required this.value,
    required this.hits,
  });

  final EffectTarget target;
  final Stat stat;
  final StatChangeType changeType;
  final StarValues value;
  final int hits;
}
