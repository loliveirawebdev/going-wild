import 'package:going_wild/domain/models/combat/combat_result.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/phase/phase_status.dart';
import 'package:going_wild/domain/use_cases/round/start_round.dart';

({MatchProgress matchProgress, CombatResult combatResult}) fightRound(MatchProgress matchProgress, {required bool recordsHistory}) {
  matchProgress.requireInProgress();

  final engines = matchProgress.phase.engines;

  final combatResult = engines.combatEngine.simulate(
    recordsHistory: recordsHistory,
    enemies: matchProgress.currentWave.enemies,
    team: matchProgress.playerRoster.placements,
    randomGenerator: matchProgress.randomGenerator,
  );

  final player = combatResult.isLost
      ? engines.playerEngine.playerAfterLostRound(matchProgress: matchProgress, combatResult: combatResult)
      : matchProgress.player;
  final foughtMatchProgress = matchProgress.createCopyWith(player: player);

  if (player.isOutOfLives) {
    return (
      matchProgress: foughtMatchProgress.createCopyWith(status: PhaseStatus.lost),
      combatResult: combatResult,
    );
  }

  if (matchProgress.currentRoundNumber == matchProgress.phase.roundCount) {
    return (
      matchProgress: foughtMatchProgress.createCopyWith(status: PhaseStatus.won),
      combatResult: combatResult,
    );
  }

  return (
    matchProgress: startRound(foughtMatchProgress.createCopyWith(currentRoundNumber: matchProgress.currentRoundNumber + 1)),
    combatResult: combatResult,
  );
}
