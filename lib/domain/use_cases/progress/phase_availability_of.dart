import 'package:going_wild/domain/models/phase/phase.dart';
import 'package:going_wild/domain/models/progress/phase_availability.dart';
import 'package:going_wild/domain/models/progress/phase_progress.dart';

PhaseAvailability phaseAvailabilityOf(Phase phase, {required List<Phase> phases, required PhaseProgress progress}) {
  if (progress.hasWon(phase.id)) return const WonPhaseAvailability();

  final phaseIndex = phases.indexOf(phase);
  final previousPhase = phaseIndex > 0 ? phases[phaseIndex - 1] : null;
  if (previousPhase != null && !progress.hasWon(previousPhase.id)) return LockedPhaseAvailability(phaseToWin: previousPhase);

  return const OpenPhaseAvailability();
}

int firstPhaseToPlayIndexOf(List<Phase> phases, {required PhaseProgress progress}) {
  final firstOpenIndex = phases.indexWhere(
    (phase) => phaseAvailabilityOf(phase, phases: phases, progress: progress) is OpenPhaseAvailability,
  );
  return firstOpenIndex == -1 ? 0 : firstOpenIndex;
}
