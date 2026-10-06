import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/combat_history/entries/combat_history_entry.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';
import 'package:going_wild/ui/core/localization/configure_plural_resolvers.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/states/combat_playback_state.dart';
import 'package:going_wild/ui/game/widgets/match_field/combat/damage/floating_damage_number.dart';

import '../match_shelves/fight_shelf_test.dart';

void main() {
  setUpAll(configurePluralResolvers);

  testWidgets('damage dealt to the predators rises above them as small numbers that fade away, damage to the team shows nothing', (
    tester,
  ) async {
    final (matchRepository, combatPlaybackBloc, clock) = await showMatch(tester);
    final matchProgress = matchRepository.currentMatchProgress!;
    matchRepository.replaceMatchProgress(
      matchProgress.createCopyWith(
        playerRoster: matchProgress.playerRoster.createCopyWith(
          placements: const [Placement(position: Position(row: 4, column: 1), characterCopy: CharacterCopy(stars: 2, character: bull))],
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

    var enemyHits = 0;
    var teamHits = 0;
    while (combatPlaybackBloc.state is PlayingCombatPlaybackState) {
      clock.beat();
      await tester.pump();

      final playbackState = combatPlaybackBloc.state;
      if (playbackState is! PlayingCombatPlaybackState) break;
      final factionsById = {for (final combatant in playbackState.currentFrame.combatants) combatant.id: combatant.faction};
      for (final hit in playbackState.entriesSincePreviousTick.whereType<DamageTakenHistoryEntry>()) {
        if (hit.amount < 0.5) continue;
        if (factionsById[hit.combatantId] == Faction.enemy) enemyHits++;
        if (factionsById[hit.combatantId] == Faction.team) teamHits++;
      }
    }

    expect(enemyHits, greaterThan(0));
    expect(teamHits, greaterThan(0));
    expect(find.byType(FloatingDamageNumber), findsNWidgets(enemyHits));

    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(FloatingDamageNumber), findsNothing);

    await tester.pumpWidget(const SizedBox());
  });
}
