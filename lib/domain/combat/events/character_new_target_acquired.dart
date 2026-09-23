part of 'battle_event.dart';

class CharacterNewTargetAcquired extends BattleEvent {
  const CharacterNewTargetAcquired({required super.time, required this.unitId, required this.targetUnitId});

  final int unitId;
  final int targetUnitId;
}
