import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/models/match_progress/errors/round_beyond_phase_error.dart';

import '../../../helpers/use_case_helpers.dart';

void main() {
  test('the current wave is the wave of the current round', () {
    final matchProgress = startWith([oneRat, fiveRats]).createCopyWith(currentRoundNumber: 2);
    expect(matchProgress.currentWave, fiveRats);
  });

  test('asking the wave of a round beyond the phase fails', () {
    final matchProgress = startWith([oneRat]).createCopyWith(currentRoundNumber: 2);
    expect(() => matchProgress.currentWave, throwsA(isA<RoundBeyondPhaseError>()));
  });
}
