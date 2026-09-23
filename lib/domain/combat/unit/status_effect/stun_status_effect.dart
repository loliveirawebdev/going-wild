part of 'status_effect.dart';

class StunStatusEffect extends StatusEffect {
  StunStatusEffect({
    required super.sourceUnit,
    required this.remainingSeconds,
  });

  double remainingSeconds;

  @override
  StatusEffectKind get statusEffectKind => StatusEffectKind.stun;
}
