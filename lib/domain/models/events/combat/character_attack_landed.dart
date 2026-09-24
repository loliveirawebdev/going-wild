part of 'battle_event.dart';

class CharacterAttackLanded extends BattleEvent {
  const CharacterAttackLanded({required super.time, required this.unitId, required this.targetUnitId});

  final int unitId;
  final int targetUnitId;
}
