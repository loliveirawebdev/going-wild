import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/ui/core/localization/configure_plural_resolvers.dart';
import 'package:going_wild/ui/game/widgets/match_field/combat/combat_unit.dart';
import 'package:going_wild/ui/game/widgets/match_field/drop_target/field_drop_target.dart';

import '../match_shelves/fight_shelf_test.dart';

void main() {
  setUpAll(configurePluralResolvers);

  testWidgets('during the fight only the combat layers follow the replay, the rest of the field is left alone', (tester) async {
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

    final dropTargetBefore = tester.widget<FieldDropTarget>(find.byType(FieldDropTarget));
    final firstUnitBefore = tester.widget<CombatUnit>(find.byType(CombatUnit).first);

    clock.beat();
    await tester.pump();
    clock.beat();
    await tester.pump();

    expect(tester.widget<FieldDropTarget>(find.byType(FieldDropTarget)), same(dropTargetBefore));
    expect(tester.widget<CombatUnit>(find.byType(CombatUnit).first), isNot(same(firstUnitBefore)));

    await tester.pumpWidget(const SizedBox());
  });
}
