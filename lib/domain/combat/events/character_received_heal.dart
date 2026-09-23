part of 'battle_event.dart';

class CharacterReceivedHeal extends BattleEvent {
  const CharacterReceivedHeal({
    required super.time,
    required this.unitId,
    required this.amount,
    required this.sourceUnitId,
    required this.healthAfterHeal,
  });

  final int unitId;
  final double amount;
  final int sourceUnitId;
  final double healthAfterHeal;
}
