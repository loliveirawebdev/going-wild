part of 'battle_event.dart';

class CharacterStatusEffectEnded extends BattleEvent {
  const CharacterStatusEffectEnded({required super.time, required this.unitId, required this.statusEffectKind});

  final int unitId;
  final StatusEffectKind statusEffectKind;
}
