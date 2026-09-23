part of 'battle_event.dart';

class CharacterReceivedMana extends BattleEvent {
  const CharacterReceivedMana({
    required super.time,
    required this.unitId,
    required this.amount,
    required this.manaAfterReceived,
  });

  final int unitId;
  final double amount;
  final double manaAfterReceived;
}
