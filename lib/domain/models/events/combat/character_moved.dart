part of 'battle_event.dart';

class CharacterMoved extends BattleEvent {
  const CharacterMoved({required super.time, required this.unitId, required this.to, required this.from});

  final int unitId;
  final Position to;
  final Position from;
}
