import 'dart:math';

import '../events/phase/phase_event.dart';
import '../player/player.dart';
import 'enemy_wave.dart';
import 'phase.dart';
import 'phase_rules.dart';
import 'phase_status.dart';

class PhaseRun {
  PhaseRun({
    required this.phase,
    required this.rules,
    required this.player,
    required this.randomGenerator,
  }) {
    remainingLives = rules.startingPlayerLives;
  }

  final Phase phase;
  final Player player;
  final PhaseRules rules;
  final Random randomGenerator;

  late int remainingLives;
  int currentRoundNumber = 1;
  PhaseStatus status = PhaseStatus.inProgress;
  final List<PhaseEvent> events = [];

  bool get isInProgress => status == PhaseStatus.inProgress;
  void recordEvent(PhaseEvent event) => events.add(event);
  EnemyWave get currentEnemyWave => phase.enemyWaves[currentRoundNumber - 1];
}
