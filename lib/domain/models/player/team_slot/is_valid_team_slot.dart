import '../../phase/phase_run.dart';
import 'team_slot.dart';

bool isValidTeamSlot(PhaseRun phaseRun, TeamSlot slot) => switch (slot) {
  BenchSlot() => slot.index >= 0 && slot.index < phaseRun.player.bench.length,
  FieldSlot() => phaseRun.rules.board.isPositionOnTeamHalf(slot.position),
};
