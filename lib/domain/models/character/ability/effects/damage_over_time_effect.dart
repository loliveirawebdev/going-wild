part of '../ability_effect.dart';

class DamageOverTimeEffect extends AbilityEffect {
  const DamageOverTimeEffect({required this.target, required this.valuePerSecond, required this.seconds});

  final EffectTarget target;
  final StarValues valuePerSecond;
  final StarValues seconds;
}
