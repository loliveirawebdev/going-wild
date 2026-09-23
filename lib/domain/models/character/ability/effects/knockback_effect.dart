part of '../ability_effect.dart';

class KnockbackEffect extends AbilityEffect {
  const KnockbackEffect({required this.target, required this.cells});

  final EffectTarget target;
  final int cells;
}
