part of 'battle_event.dart';

class CharacterReceivedShield extends BattleEvent {
  const CharacterReceivedShield({
    required super.time,
    required this.unitId,
    required this.sourceUnitId,
    required this.amount,
  });

  final int unitId;
  final int sourceUnitId;
  final double amount;
}
