import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/engines/player/basic_player_engine.dart';
import 'package:going_wild/domain/models/match_progress/errors/match_is_over_error.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/phase/phase_status.dart';

import '../../../helpers/use_case_helpers.dart';

void main() {
  group('fighting', () {
    test('winning a round keeps every life and opens the next round with its reward', () {
      final matchProgress = startWith([oneRat, fiveRats]).createCopyWithPlayerPlacements(threeStarBullOnBoard);

      final fought = fightRound(matchProgress, recordsHistory: false);

      expect(fought.combatResult.isLost, isFalse);
      expect(fought.matchProgress.player.remainingLives, basicPlayerEngine.startingLives);
      expect(fought.matchProgress.currentRoundNumber, 2);
      expect(fought.matchProgress.player.coins, matchProgress.player.coins + fiveRats.coinsReward);
      expect(fought.matchProgress.playerRoster.placements, matchProgress.playerRoster.placements);
    });

    test('a lost round takes the lives of the player engine', () {
      final fought = fightRound(startWith([fiveRats, oneRat]), recordsHistory: false);

      expect(fought.combatResult.isLost, isTrue);
      expect(fought.matchProgress.player.remainingLives, basicPlayerEngine.startingLives - basicPlayerEngine.livesLostPerLostRound);
      expect(fought.matchProgress.status, PhaseStatus.inProgress);
    });

    test('losing every life loses the phase and every action fails', () {
      var matchProgress = startWith([fiveRats, fiveRats, fiveRats, oneRat]);
      for (var lostRound = 0; lostRound < basicPlayerEngine.startingLives; lostRound++) {
        matchProgress = fightRound(matchProgress, recordsHistory: false).matchProgress;
      }

      expect(matchProgress.status, PhaseStatus.lost);
      expect(() => fightRound(matchProgress, recordsHistory: false), throwsA(isA<MatchIsOverError>()));
      expect(() => rerollShop(matchProgress), throwsA(isA<MatchIsOverError>()));
      expect(() => buyExperience(matchProgress), throwsA(isA<MatchIsOverError>()));
    });

    test('clearing the last round wins the phase with no new round', () {
      var matchProgress = startWith([oneRat, oneRat]).createCopyWithPlayerPlacements(threeStarBullOnBoard);
      matchProgress = fightRound(matchProgress, recordsHistory: false).matchProgress;
      final coinsBeforeLastRound = matchProgress.player.coins;

      matchProgress = fightRound(matchProgress, recordsHistory: false).matchProgress;

      expect(matchProgress.status, PhaseStatus.won);
      expect(matchProgress.currentRoundNumber, 2);
      expect(matchProgress.player.coins, coinsBeforeLastRound);
    });

    test('the same seed plays the same round', () {
      MatchProgress start() => startWith([fiveRats], seed: 9).createCopyWithPlayerPlacements(threeStarBullOnBoard);

      final first = fightRound(start(), recordsHistory: false);
      final second = fightRound(start(), recordsHistory: false);

      expect(first.combatResult.elapsedSeconds, second.combatResult.elapsedSeconds);
      expect(first.combatResult.winningFaction, second.combatResult.winningFaction);
      expect(
        first.combatResult.combatants.map((combatant) => combatant.currentHealth),
        second.combatResult.combatants.map((combatant) => combatant.currentHealth),
      );
    });
  });
}
