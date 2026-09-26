import 'dart:math';

import '../level/player_level_progress.dart';
import '../phase/phase.dart';
import '../phase/phase_status.dart';
import '../phase/phase_wave.dart';
import '../player/player.dart';
import '../roster/roster.dart';
import '../shop/shop.dart';
import 'errors/match_is_over_error.dart';
import 'errors/round_beyond_phase_error.dart';

class MatchProgress {
  const MatchProgress({
    required this.shop,
    required this.phase,
    required this.status,
    required this.player,
    required this.playerRoster,
    required this.randomGenerator,
    required this.currentRoundNumber,
    required this.playerLevelProgress,
  });

  final Shop shop;
  final Phase phase;
  final Player player;
  final PhaseStatus status;
  final Roster playerRoster;
  final int currentRoundNumber;
  final Random randomGenerator;
  final PlayerLevelProgress playerLevelProgress;

  bool get isInProgress => status == PhaseStatus.inProgress;

  void requireInProgress() {
    if (!isInProgress) {
      throw MatchIsOverError();
    }
  }

  PhaseWave get currentWave {
    if (currentRoundNumber < 1 || currentRoundNumber > phase.roundCount) {
      throw RoundBeyondPhaseError(
        roundCount: phase.roundCount,
        roundNumber: currentRoundNumber,
      );
    }

    return phase.waves[currentRoundNumber - 1];
  }

  MatchProgress createCopyWith({
    Shop? shop,
    Player? player,
    PhaseStatus? status,
    Roster? playerRoster,
    int? currentRoundNumber,
    PlayerLevelProgress? playerLevelProgress,
  }) => MatchProgress(
    phase: phase,
    shop: shop ?? this.shop,
    status: status ?? this.status,
    player: player ?? this.player,
    randomGenerator: randomGenerator,
    playerRoster: playerRoster ?? this.playerRoster,
    currentRoundNumber: currentRoundNumber ?? this.currentRoundNumber,
    playerLevelProgress: playerLevelProgress ?? this.playerLevelProgress,
  );
}
