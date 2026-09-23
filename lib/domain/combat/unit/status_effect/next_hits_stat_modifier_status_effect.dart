part of 'status_effect.dart';

class NextHitsStatModifierStatusEffect extends StatusEffect implements StatModification {
  NextHitsStatModifierStatusEffect({
    required super.sourceUnit,
    required this.stat,
    required this.changeType,
    required this.value,
    required this.remainingHits,
  });

  int remainingHits;

  @override
  final Stat stat;

  @override
  final StatChangeType changeType;

  @override
  final double value;

  @override
  StatusEffectKind get statusEffectKind => StatusEffectKind.nextHitsStatModifier;
}
