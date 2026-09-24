import 'dart:math';

import '../../models/phase/phase.dart';
import '../../models/phase/phase_rules.dart';
import '../../models/phase/phase_run.dart';
import '../../models/player/player.dart';
import 'start_round.dart';

PhaseRun startPhase(Phase phase, PhaseRules rules, Random randomGenerator) {
  final phaseRun = PhaseRun(phase: phase, rules: rules, player: Player(coins: 0), randomGenerator: randomGenerator);
  startRound(phaseRun);
  return phaseRun;
}
