import '../combat/battle_result.dart';

class RoundResult {
  const RoundResult({required this.roundNumber, required this.livesTaken, required this.battleResult});

  final int roundNumber;
  final int livesTaken;
  final BattleResult battleResult;
}
