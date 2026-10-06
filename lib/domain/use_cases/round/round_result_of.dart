import 'package:going_wild/domain/models/combat/combat_result.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/round_result/round_result.dart';

RoundResult roundResultOf({
  required CombatResult combatResult,
  required MatchProgress matchProgressAfterFight,
  required MatchProgress matchProgressBeforeFight,
}) {
  final levelEngine = matchProgressAfterFight.phase.engines.levelEngine;

  return RoundResult(
    isVictory: !combatResult.isLost,
    roundNumber: matchProgressBeforeFight.currentRoundNumber,
    coinsGained: matchProgressAfterFight.player.coins - matchProgressBeforeFight.player.coins,
    livesLost: matchProgressBeforeFight.player.remainingLives - matchProgressAfterFight.player.remainingLives,
    experienceGained: matchProgressAfterFight.isInProgress ? levelEngine.experienceForRound(matchProgress: matchProgressAfterFight) : 0,
  );
}
