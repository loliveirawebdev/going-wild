part of 'battle_event.dart';

class CharacterDamaged extends BattleEvent {
  const CharacterDamaged({
    required super.time,
    required this.amount,
    required this.unitId,
    required this.sourceId,
    required this.remainingHealth,
    required this.absorbedByShield,
  });

  final int unitId;
  final int sourceId;
  final double amount;
  final double absorbedByShield;
  final double remainingHealth;
}
