part of 'battle_event.dart';

class CharacterAbilityCast extends BattleEvent {
  const CharacterAbilityCast({required super.time, required this.unitId, required this.abilityId});

  final int unitId;
  final String abilityId;
}
