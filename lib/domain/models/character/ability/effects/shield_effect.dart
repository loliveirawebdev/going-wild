part of '../ability_effect.dart';

class ShieldEffect extends AbilityEffect {
  const ShieldEffect({required this.target, required this.value, required this.seconds, this.onExpire = const []});

  final EffectTarget target;
  final StarValues value;
  final StarValues seconds;
  final List<AbilityEffect> onExpire;
}
