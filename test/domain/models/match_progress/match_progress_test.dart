import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/set/sets.dart';
import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/match_progress/errors/round_beyond_phase_error.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';

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

  test('only the animals on the field count for the sets, the bench never does', () {
    final matchProgress = startWith([oneRat]);
    final withBullOnBench = matchProgress.createCopyWith(
      playerRoster: matchProgress.playerRoster.createCopyWith(
        inventory: matchProgress.playerRoster.inventory.createCopyWithEntryAt(0, const CharacterCopy(stars: 1, character: horse)),
        placements: const [
          Placement(
            position: Position(row: 6, column: 1),
            characterCopy: CharacterCopy(stars: 1, character: bull),
          ),
        ],
      ),
    );

    final brutesPresence = withBullOnBench.setPresences.firstWhere((setPresence) => setPresence.set == brutes);
    expect(brutesPresence.presentMembers, [bull]);
    expect(withBullOnBench.activeSets.where((activeSet) => activeSet.set == brutes), isEmpty);
  });

  test('the team is full once the field holds as many animals as the level allows', () {
    final matchProgress = startWith([oneRat]);
    final positions = [for (var column = 1; column <= matchProgress.teamLimit; column++) Position(row: 6, column: column)];
    MatchProgress withTeamOf(int count) => matchProgress.createCopyWith(
      playerRoster: matchProgress.playerRoster.createCopyWith(
        placements: [
          for (final position in positions.take(count))
            Placement(
              position: position,
              characterCopy: const CharacterCopy(stars: 1, character: dog),
            ),
        ],
      ),
    );

    expect(withTeamOf(matchProgress.teamLimit - 1).isTeamFull, isFalse);
    expect(withTeamOf(matchProgress.teamLimit).teamSize, matchProgress.teamLimit);
    expect(withTeamOf(matchProgress.teamLimit).isTeamFull, isTrue);
  });
}
