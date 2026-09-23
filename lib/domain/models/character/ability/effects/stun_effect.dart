part of '../ability_effect.dart';

class StunEffect extends AbilityEffect {
  const StunEffect({required this.target, required this.seconds});

  final EffectTarget target;
  final StarValues seconds;
}
