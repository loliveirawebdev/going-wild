part of 'status_effect.dart';

class VanishedStatusEffect extends StatusEffect {
  VanishedStatusEffect({
    required super.sourceUnit,
    required this.remainingSeconds,
    required this.reappearNextToUnit,
  });

  double remainingSeconds;
  final Unit reappearNextToUnit;

  @override
  StatusEffectKind get statusEffectKind => StatusEffectKind.vanished;
}
