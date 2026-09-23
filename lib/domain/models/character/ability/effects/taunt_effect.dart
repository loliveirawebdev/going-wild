part of '../ability_effect.dart';

class TauntEffect extends AbilityEffect {
  const TauntEffect({required this.target, required this.seconds});

  final EffectTarget target;
  final StarValues seconds;
}
