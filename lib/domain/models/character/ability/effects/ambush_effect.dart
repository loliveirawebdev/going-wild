part of '../ability_effect.dart';

class AmbushEffect extends AbilityEffect {
  const AmbushEffect({required this.target, required this.seconds});

  final EffectTarget target;
  final StarValues seconds;
}
