part of 'status_effect.dart';

class DamageOverTimeStatusEffect extends StatusEffect {
  DamageOverTimeStatusEffect({
    required super.sourceUnit,
    required this.damagePerSecond,
    required this.remainingSeconds,
  });

  final double damagePerSecond;
  double remainingSeconds;

  @override
  StatusEffectKind get statusEffectKind => StatusEffectKind.damageOverTime;
}
