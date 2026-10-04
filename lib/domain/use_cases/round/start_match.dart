import 'dart:math';

import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/match_progress/round_stage.dart';
import 'package:going_wild/domain/models/phase/phase.dart';
import 'package:going_wild/domain/models/phase/phase_status.dart';
import 'package:going_wild/domain/models/roster/roster.dart';
import 'package:going_wild/domain/use_cases/round/start_round.dart';

MatchProgress startMatch(Phase phase, {required Random randomGenerator}) {
  final engines = phase.engines;

  return startRound(
    MatchProgress(
      phase: phase,
      currentRoundNumber: 1,
      status: PhaseStatus.inProgress,
      roundStage: RoundStage.preparing,
      randomGenerator: randomGenerator,
      shop: engines.shopEngine.startingShop(),
      player: engines.playerEngine.startingPlayer(startingCoins: engines.economyEngine.startingCoins),
      playerLevelProgress: engines.levelEngine.startingProgress(),
      playerRoster: Roster(placements: const [], inventory: engines.inventoryEngine.emptyInventory()),
    ),
  );
}
