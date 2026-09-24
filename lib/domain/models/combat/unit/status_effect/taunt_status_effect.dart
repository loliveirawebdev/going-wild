part of 'status_effect.dart';

class TauntStatusEffect extends StatusEffect {
  TauntStatusEffect({
    required super.sourceUnit,
    required this.remainingSeconds,
  });

  double remainingSeconds;

  @override
  StatusEffectKind get statusEffectKind => StatusEffectKind.taunt;
}
