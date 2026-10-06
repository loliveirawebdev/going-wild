import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/phase/backyard/backyard.dart';
import 'package:going_wild/domain/use_cases/round/round_result_of.dart';
import 'package:going_wild/domain/use_cases/round/start_fight.dart';
import 'package:going_wild/domain/use_cases/round/start_match.dart';

void main() {
  test('a first round lost with no team costs a life, still pays coins and grants the round experience', () {
    final matchProgress = startMatch(backyard, randomGenerator: Random(1));
    final startedFight = startFight(matchProgress, recordsHistory: false);

    final roundResult = roundResultOf(
      combatResult: startedFight.combatResult,
      matchProgressBeforeFight: matchProgress,
      matchProgressAfterFight: startedFight.matchProgressAfterFight,
    );

    expect(roundResult.isVictory, isFalse);
    expect(roundResult.roundNumber, 1);
    expect(roundResult.livesLost, 1);
    expect(roundResult.coinsGained, startedFight.matchProgressAfterFight.player.coins - matchProgress.player.coins);
    expect(roundResult.experienceGained, backyard.engines.levelEngine.experienceForRound(matchProgress: startedFight.matchProgressAfterFight));
  });
}
