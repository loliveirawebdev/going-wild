part of 'battle_event.dart';

class CharacterDied extends BattleEvent {
  const CharacterDied({required super.time, required this.unitId, required this.killerUnitId});

  final int unitId;
  final int killerUnitId;
}
