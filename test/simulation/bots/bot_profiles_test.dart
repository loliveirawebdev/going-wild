import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/phase/backyard/backyard.dart';
import 'package:going_wild/domain/models/phase/phase_status.dart';
import 'package:going_wild/domain/use_cases/round/fight_round.dart';
import 'package:going_wild/domain/use_cases/round/start_match.dart';
import 'package:going_wild/simulation/bots/bot_profiles.dart';

void main() {
  for (final botProfile in allBotProfiles) {
    test('the ${botProfile.name} bot plays a whole backyard match', () {
      final botRandomGenerator = Random(7919);
      var matchProgress = startMatch(backyard, randomGenerator: Random(1));

      while (matchProgress.isInProgress) {
        final playedMatchProgress = botProfile.playRound(matchProgress, botRandomGenerator);
        final teamSize = playedMatchProgress.playerLevelProgress.level.teamSize;

        expect(playedMatchProgress.playerRoster.placements.length, lessThanOrEqualTo(teamSize));
        matchProgress = fightRound(playedMatchProgress, recordsHistory: false).matchProgress;
      }

      expect(matchProgress.status, isNot(PhaseStatus.inProgress));
    });
  }

  test('every bot profile has its own name', () {
    final names = allBotProfiles.map((botProfile) => botProfile.name).toList();
    expect(names.toSet().length, names.length);
  });
}
