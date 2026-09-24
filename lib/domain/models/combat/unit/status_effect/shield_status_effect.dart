part of 'status_effect.dart';

class ShieldStatusEffect extends StatusEffect {
  ShieldStatusEffect({
    required super.sourceUnit,
    required this.remainingShield,
    required this.remainingSeconds,
    required this.onExpire,
  });

  double remainingShield;
  double remainingSeconds;
  final List<AbilityEffect> onExpire;

  @override
  StatusEffectKind get statusEffectKind => StatusEffectKind.shield;
}
