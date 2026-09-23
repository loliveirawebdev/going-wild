part of '../ability_effect.dart';

class HealEffect extends AbilityEffect {
  const HealEffect({required this.target, required this.valuePerSecond, required this.seconds});

  final EffectTarget target;
  final StarValues valuePerSecond;
  final StarValues seconds;
}
