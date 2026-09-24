part of 'battle_event.dart';

class CharacterStatusEffectStarted extends BattleEvent {
  const CharacterStatusEffectStarted({
    required super.time,
    required this.unitId,
    required this.sourceUnitId,
    required this.statusEffectKind,
  });

  final int unitId;
  final int sourceUnitId;
  final StatusEffectKind statusEffectKind;
}
