part of 'status_effect.dart';

class StatModifierStatusEffect extends StatusEffect implements StatModification {
  StatModifierStatusEffect({
    required this.stat,
    required this.value,
    required this.changeType,
    required super.sourceUnit,
    required this.remainingSeconds,
  });

  double remainingSeconds;

  @override
  final Stat stat;

  @override
  final StatChangeType changeType;

  @override
  final double value;

  @override
  StatusEffectKind get statusEffectKind => StatusEffectKind.statModifier;
}
