import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';
import 'package:going_wild/ui/core/localization/configure_plural_resolvers.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/states/combat_playback_state.dart';
import 'package:going_wild/ui/game/widgets/match_field/combat/combat_unit.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_sheet.dart';

import '../match_shelves/fight_shelf_test.dart';

void main() {
  setUpAll(configurePluralResolvers);

  testWidgets('the sheet of a predator opened during the fight follows its health live until it falls', (tester) async {
    final (matchRepository, combatPlaybackBloc, clock) = await showMatch(tester);
    final matchProgress = matchRepository.currentMatchProgress!;
    matchRepository.replaceMatchProgress(
      matchProgress.createCopyWith(
        playerRoster: matchProgress.playerRoster.createCopyWith(
          placements: const [
            Placement(
              position: Position(row: 4, column: 1),
              characterCopy: CharacterCopy(stars: 3, character: bull),
            ),
            Placement(
              position: Position(row: 4, column: 2),
              characterCopy: CharacterCopy(stars: 3, character: dog),
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

    final predatorToken = find.byWidgetPredicate((widget) => widget is CombatUnit && widget.combatant.faction == Faction.enemy);
    await tester.tap(predatorToken.first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    UnitSheet openSheet() => tester.widget<UnitSheet>(find.byType(UnitSheet));
    final startingHealth = openSheet().combatant!.currentHealth;
    expect(startingHealth, openSheet().combatant!.maxHealth);

    while (combatPlaybackBloc.state is PlayingCombatPlaybackState && openSheet().combatant!.isAlive) {
      clock.beat();
      await tester.pump();
    }

    expect(openSheet().combatant!.currentHealth, lessThan(startingHealth));
    expect(openSheet().combatant!.isAlive, isFalse);
    expect(find.text('Caído'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });
}
