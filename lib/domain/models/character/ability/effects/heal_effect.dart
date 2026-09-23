part of '../ability_effect.dart';

class HealEffect extends AbilityEffect {
  const HealEffect({required this.target, required this.healPerSecond, required this.seconds});

  final EffectTarget target;
  final StarValues healPerSecond;
  final StarValues seconds;
}
