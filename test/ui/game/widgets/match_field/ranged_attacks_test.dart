import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/combat_history/entries/combat_history_entry.dart';
import 'package:going_wild/ui/core/localization/configure_plural_resolvers.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/states/combat_playback_state.dart';
import 'package:going_wild/ui/game/widgets/match_field/combat/projectiles/thrown_pebble.dart';

import '../match_shelves/fight_shelf_test.dart';

void main() {
  setUpAll(configurePluralResolvers);

  testWidgets('every ranged attack throws a pebble from the attacker to its target, melee attacks throw nothing', (tester) async {
    final (matchRepository, combatPlaybackBloc, clock) = await showMatch(tester);
    final matchProgress = matchRepository.currentMatchProgress!;
    matchRepository.replaceMatchProgress(
      matchProgress.createCopyWith(
        playerRoster: matchProgress.playerRoster.createCopyWith(
          placements: const [
            Placement(
              position: Position(row: 4, column: 1),
              characterCopy: CharacterCopy(stars: 2, character: bull),
            ),
            Placement(
              position: Position(row: 6, column: 2),
              characterCopy: CharacterCopy(stars: 2, character: queenBee),
            ),
          ],
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Lutar!'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();

    var rangedAttacks = 0;
    var meleeAttacks = 0;
    while (combatPlaybackBloc.state is PlayingCombatPlaybackState) {
      clock.beat();
      await tester.pump();

      final playbackState = combatPlaybackBloc.state;
      if (playbackState is! PlayingCombatPlaybackState) break;
      final rangesById = {for (final combatant in playbackState.currentFrame.combatants) combatant.id: combatant.attackRange};
      for (final attack in playbackState.entriesSincePreviousTick.whereType<AttackLandedHistoryEntry>()) {
        if ((rangesById[attack.combatantId] ?? 0) > 1) {
          rangedAttacks++;
        } else {
          meleeAttacks++;
        }
      }
    }

    expect(rangedAttacks, greaterThan(0));
    expect(meleeAttacks, greaterThan(0));
    expect(find.byType(ThrownPebble), findsNWidgets(rangedAttacks));

    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(ThrownPebble), findsNothing);

    await tester.pumpWidget(const SizedBox());
  });
}
