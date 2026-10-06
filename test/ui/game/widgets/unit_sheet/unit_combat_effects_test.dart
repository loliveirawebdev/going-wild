import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/phase/backyard/backyard.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay_combatant.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/lasting/combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/damage_over_time/damage_over_time_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/heal_over_time/heal_over_time_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/stun/stun_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/catalog/taunt/taunt_combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/configure_plural_resolvers.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_combat_effects.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_sheet.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_side.dart';

const catCopy = CharacterCopy(stars: 1, character: cat);

CombatReplayCombatant combatantWith({double currentHealth = 230, List<CombatLastingEffect> effects = const []}) => CombatReplayCombatant(
  id: 1,
  maxMana: 60,
  maxHealth: 500,
  attackRange: 1,
  currentMana: 22,
  faction: Faction.team,
  characterCopy: catCopy,
  targetCombatantId: null,
  combatLastingEffects: effects,
  currentHealth: currentHealth,
  position: const Position(row: 5, column: 1),
);

Future<Rect> showSheetOf(WidgetTester tester, CombatReplayCombatant combatant) async {
  await tester.pumpWidget(
    TranslationProvider(
      child: MaterialApp(
        home: Scaffold(
          body: UnitSheet(side: UnitSide.team, engines: backyard.engines, characterCopy: catCopy, combatant: combatant),
        ),
      ),
    ),
  );
  return tester.getRect(find.byType(UnitCombatEffects));
}

void main() {
  setUpAll(configurePluralResolvers);

  testWidgets('the effects row keeps the same place whether it is empty, crowded or showing a fallen animal', (tester) async {
    tester.view.physicalSize = const Size(402, 874) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final emptyRow = await showSheetOf(tester, combatantWith());
    expect(find.text('Nenhum efeito ativo'), findsOneWidget);

    final crowdedRow = await showSheetOf(
      tester,
      combatantWith(
        effects: const [
          StunCombatLastingEffect(remainingTicks: 4, sourceCombatantId: 2),
          TauntCombatLastingEffect(remainingTicks: 4, sourceCombatantId: 2),
          DamageOverTimeCombatLastingEffect(remainingTicks: 4, damagePerSecond: 10, sourceCombatantId: 2),
          HealOverTimeCombatLastingEffect(remainingTicks: 4, healPerSecond: 10, sourceCombatantId: 3),
        ],
      ),
    );
    expect(find.text('Nenhum efeito ativo'), findsNothing);
    expect(find.text('Atordoado'), findsOneWidget);

    final fallenRow = await showSheetOf(tester, combatantWith(currentHealth: 0));
    expect(find.text('Caído'), findsOneWidget);

    expect(crowdedRow, emptyRow);
    expect(fallenRow.height, emptyRow.height);
  });
}
