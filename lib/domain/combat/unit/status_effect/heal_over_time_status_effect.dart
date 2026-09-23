part of 'status_effect.dart';

class HealOverTimeStatusEffect extends StatusEffect {
  HealOverTimeStatusEffect({
    required super.sourceUnit,
    required this.healPerSecond,
    required this.remainingSeconds,
  });

  final double healPerSecond;
  double remainingSeconds;

  @override
  StatusEffectKind get statusEffectKind => StatusEffectKind.healOverTime;
}
