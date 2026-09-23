part of '../ability_effect.dart';

class LifestealEffect extends AbilityEffect {
  const LifestealEffect({required this.target, required this.value});

  final EffectTarget target;
  final StarValues value;
}
