import 'dart:math';

import '../../models/match_progress/match_progress.dart';
import '../../models/phase/phase.dart';
import '../../models/phase/phase_status.dart';
import '../../models/roster/roster.dart';
import 'start_round.dart';

class StartMatch {
  const StartMatch();

  MatchProgress call(Phase phase, {required Random randomGenerator}) {
    const startRound = StartRound();
    final engines = phase.engines;

    return startRound(
      MatchProgress(
        phase: phase,
        currentRoundNumber: 1,
        status: PhaseStatus.inProgress,
        randomGenerator: randomGenerator,
        shop: engines.shopEngine.startingShop(),
        player: engines.playerEngine.startingPlayer(startingCoins: engines.economyEngine.startingCoins),
        playerLevelProgress: engines.levelEngine.startingProgress(),
        playerRoster: Roster(placements: const [], inventory: engines.inventoryEngine.emptyInventory()),
      ),
    );
  }
}
