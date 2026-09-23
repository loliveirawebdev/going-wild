part of '../ability_effect.dart';

class DamageEffect extends AbilityEffect {
  const DamageEffect({required this.target, required this.value});

  final EffectTarget target;
  final StarValues value;
}
