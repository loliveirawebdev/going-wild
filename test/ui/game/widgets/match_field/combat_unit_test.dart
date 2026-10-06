import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay_combatant.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/configure_plural_resolvers.dart';
import 'package:going_wild/ui/game/widgets/match_field/combat/combat_unit.dart';

CombatReplayCombatant dogWith({required double currentHealth}) => CombatReplayCombatant(
  id: 1,
  maxMana: 60,
  maxHealth: 500,
  attackRange: 1,
  currentMana: 20,
  faction: Faction.team,
  targetCombatantId: null,
  combatLastingEffects: const [],
  currentHealth: currentHealth,
  position: const Position(row: 5, column: 1),
  characterCopy: const CharacterCopy(stars: 1, character: dog),
);

Widget unitOf(CombatReplayCombatant combatant) => TranslationProvider(
  child: MaterialApp(
    home: Center(child: CombatUnit(diameter: 40, combatant: combatant)),
  ),
);

double unitOpacity(WidgetTester tester) =>
    tester.widget<FadeTransition>(find.descendant(of: find.byType(CombatUnit), matching: find.byType(FadeTransition))).opacity.value;

void main() {
  setUpAll(configurePluralResolvers);

  testWidgets('a falling animal fades out instead of turning faded at once', (tester) async {
    await tester.pumpWidget(unitOf(dogWith(currentHealth: 300)));
    expect(unitOpacity(tester), 1);

    await tester.pumpWidget(unitOf(dogWith(currentHealth: 0)));
    await tester.pump(const Duration(milliseconds: 120));
    expect(unitOpacity(tester), allOf(greaterThan(0.45), lessThan(1)));

    await tester.pump(const Duration(milliseconds: 300));
    expect(unitOpacity(tester), closeTo(0.45, 0.001));
  });
}
