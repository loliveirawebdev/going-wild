import 'dart:math';

import 'package:going_wild/domain/models/board/placement_list.dart';
import 'package:going_wild/domain/models/level/player_level_progress.dart';
import 'package:going_wild/domain/models/match_progress/errors/fight_in_progress_error.dart';
import 'package:going_wild/domain/models/match_progress/errors/match_is_over_error.dart';
import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';
import 'package:going_wild/domain/models/match_progress/errors/round_beyond_phase_error.dart';
import 'package:going_wild/domain/models/match_progress/round_stage.dart';
import 'package:going_wild/domain/models/phase/phase.dart';
import 'package:going_wild/domain/models/phase/phase_status.dart';
import 'package:going_wild/domain/models/phase/phase_wave.dart';
import 'package:going_wild/domain/models/player/player.dart';
import 'package:going_wild/domain/models/roster/roster.dart';
import 'package:going_wild/domain/models/set/active_set.dart';
import 'package:going_wild/domain/models/set/set_presence.dart';
import 'package:going_wild/domain/models/shop/shop.dart';

class MatchProgress {
  const MatchProgress({
    required this.shop,
    required this.phase,
    required this.status,
    required this.player,
    required this.roundStage,
    required this.playerRoster,
    required this.randomGenerator,
    required this.currentRoundNumber,
    required this.playerLevelProgress,
  });

  final Shop shop;
  final Phase phase;
  final Player player;
  final PhaseStatus status;
  final RoundStage roundStage;
  final Roster playerRoster;
  final int currentRoundNumber;
  final Random randomGenerator;
  final PlayerLevelProgress playerLevelProgress;

  bool get isTeamFull => teamSize >= teamLimit;
  int get teamSize => playerRoster.placements.length;
  int get teamLimit => playerLevelProgress.level.teamSize;
  bool get isInProgress => status == PhaseStatus.inProgress;
  int get maxLives => phase.engines.playerEngine.startingLives;
  List<ActiveSet> get activeSets => phase.engines.setEngine.activeSets(playerRoster.placements.characters);
  List<SetPresence> get setPresences => phase.engines.setEngine.setPresences(playerRoster.placements.characters);

  void requireInProgress() {
    if (!isInProgress) {
      throw MatchIsOverError();
    }
  }

  RejectedPlayerActionError? checkPreparingActions() {
    if (!isInProgress) return MatchIsOverError();
    if (roundStage == RoundStage.fighting) return FightInProgressError();

    return null;
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
    RoundStage? roundStage,
    int? currentRoundNumber,
    PlayerLevelProgress? playerLevelProgress,
  }) => MatchProgress(
    phase: phase,
    shop: shop ?? this.shop,
    status: status ?? this.status,
    player: player ?? this.player,
    randomGenerator: randomGenerator,
    roundStage: roundStage ?? this.roundStage,
    playerRoster: playerRoster ?? this.playerRoster,
    currentRoundNumber: currentRoundNumber ?? this.currentRoundNumber,
    playerLevelProgress: playerLevelProgress ?? this.playerLevelProgress,
  );
}
