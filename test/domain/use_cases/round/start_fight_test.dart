import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/domain/models/match_progress/errors/fight_in_progress_error.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/match_progress/round_stage.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';
import 'package:going_wild/domain/use_cases/round/start_fight.dart';

import '../../../helpers/inventory_helpers.dart';
import '../../../helpers/use_case_helpers.dart';

MatchProgress preparedMatchProgress() {
  final withInventoryCopy = withInventory(startWith([oneRat, fiveRats]), [characterCopyOf(cat)]);
  return withCoins(withInventoryCopy, 20).createCopyWithPlayerPlacements([placed(dog, 6, 2)]);
}

void main() {
  test('a match starts preparing its first round', () {
    expect(startWith([oneRat]).roundStage, RoundStage.preparing);
  });

  test('starting a fight marks the match as fighting and keeps the result and the match after the fight', () {
    final matchProgress = preparedMatchProgress();

    final startedFight = startFight(matchProgress, recordsHistory: true);

    expect(startedFight.fightingMatchProgress.roundStage, RoundStage.fighting);
    expect(startedFight.fightingMatchProgress.player.coins, matchProgress.player.coins);
    expect(startedFight.fightingMatchProgress.currentRoundNumber, 1);
    expect(startedFight.combatResult.history.entries, isNotEmpty);
    expect(startedFight.matchProgressAfterFight.currentRoundNumber, 2);
    expect(startedFight.matchProgressAfterFight.roundStage, RoundStage.preparing);
  });

  group('while fighting, preparing actions are rejected', () {
    final fightingMatchProgress = startFight(preparedMatchProgress(), recordsHistory: false).fightingMatchProgress;
    final rejectedActions = <String, MatchProgress Function()>{
      'buying an offer': () => buyShopOffer(fightingMatchProgress, offerIndex: 0),
      'rerolling the shop': () => rerollShop(fightingMatchProgress),
      'toggling the shop lock': () => toggleShopLock(fightingMatchProgress),
      'buying experience': () => buyExperience(fightingMatchProgress),
      'moving a copy': () => moveCopyBetweenRosterSlots(
        fightingMatchProgress,
        from: const InventorySlot(index: 0),
        to: BoardSlot(position: at(6, 3)),
      ),
      'selling a copy': () => sellCopyFromRosterSlot(fightingMatchProgress, from: const InventorySlot(index: 0)),
      'starting another fight': () => startFight(fightingMatchProgress, recordsHistory: false).fightingMatchProgress,
    };

    for (final MapEntry(key: actionName, value: rejectedAction) in rejectedActions.entries) {
      test(actionName, () => expect(rejectedAction, throwsA(isA<FightInProgressError>())));
    }
  });
}
