import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/phase/phases.dart';
import 'package:going_wild/domain/models/progress/phase_availability.dart';
import 'package:going_wild/domain/models/progress/phase_progress.dart';
import 'package:going_wild/domain/use_cases/progress/phase_availability_of.dart';

const phases = [backyard, pondEdge, cornfield];

PhaseAvailability availabilityOf(int index, PhaseProgress progress) =>
    phaseAvailabilityOf(phases[index], phases: phases, progress: progress);

void main() {
  test('with nothing won only the first phase is open and each next one asks to win the one before', () {
    expect(availabilityOf(0, PhaseProgress.empty), isA<OpenPhaseAvailability>());

    final second = availabilityOf(1, PhaseProgress.empty);
    expect(second, isA<LockedPhaseAvailability>());
    expect((second as LockedPhaseAvailability).phaseToWin, backyard);
    expect((availabilityOf(2, PhaseProgress.empty) as LockedPhaseAvailability).phaseToWin, pondEdge);
  });

  test('winning a phase marks it as won and opens the next one', () {
    final progress = PhaseProgress.empty.createCopyWithPhaseWon(backyard.id);

    expect(availabilityOf(0, progress), isA<WonPhaseAvailability>());
    expect(availabilityOf(1, progress), isA<OpenPhaseAvailability>());
    expect(availabilityOf(2, progress), isA<LockedPhaseAvailability>());
  });

  test('the selection starts on the first phase still to win, or on the first one when all are won', () {
    expect(firstPhaseToPlayIndexOf(phases, progress: PhaseProgress.empty), 0);
    expect(firstPhaseToPlayIndexOf(phases, progress: PhaseProgress.empty.createCopyWithPhaseWon(backyard.id)), 1);

    final allWon = PhaseProgress(wonPhaseIds: {for (final phase in phases) phase.id});
    expect(firstPhaseToPlayIndexOf(phases, progress: allWon), 0);
  });
}
