import '../../models/combat/combat_result.dart';
import '../../models/match_progress/match_progress.dart';
import '../../models/phase/phase_status.dart';
import 'start_round.dart';

class FightRound {
  const FightRound();

  ({MatchProgress matchProgress, CombatResult combatResult}) call(MatchProgress matchProgress) {
    matchProgress.requireInProgress();

    const startRound = StartRound();
    final engines = matchProgress.phase.engines;

    final combatResult = engines.combatEngine.simulate(
      enemies: matchProgress.currentWave.enemies,
      team: matchProgress.playerRoster.placements,
      randomGenerator: matchProgress.randomGenerator,
    );

    final player = combatResult.isLost ? engines.playerEngine.afterLostRound(matchProgress.player) : matchProgress.player;
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
}
