import 'dart:math';

import '../../models/phase/phase.dart';
import '../../models/phase/phase_rules.dart';
import '../../models/phase/phase_run.dart';
import '../../models/player/player.dart';
import 'start_round.dart';

PhaseRun startPhase(Phase phase, PhaseRules rules, Random randomGenerator) {
  final phaseRun = PhaseRun(
    phase: phase,
    rules: rules,
    randomGenerator: randomGenerator,
    player: Player(coins: 0, benchSize: rules.benchSize),
  );

  startRound(phaseRun);
  return phaseRun;
}
