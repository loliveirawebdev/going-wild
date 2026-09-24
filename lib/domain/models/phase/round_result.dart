import '../combat/battle_result.dart';

class RoundResult {
  const RoundResult({required this.roundNumber, required this.isLost, required this.battleResult});

  final bool isLost;
  final int roundNumber;
  final BattleResult battleResult;
}
