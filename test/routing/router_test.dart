import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/app.dart';
import 'package:going_wild/content/phase/phases.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/routing/router.dart';
import 'package:going_wild/ui/core/localization/configure_plural_resolvers.dart';
import 'package:going_wild/ui/core/localization/phase_name.dart';
import 'package:going_wild/ui/game/widgets/game_screen.dart';
import 'package:going_wild/ui/home/widgets/home_screen.dart';
import 'package:going_wild/ui/phase_selection/widgets/phase_selection_screen.dart';
import 'package:going_wild/ui/settings/widgets/settings_screen.dart';
import 'package:talker_flutter/talker_flutter.dart';

Future<void> openTheApp(WidgetTester tester) async {
  configurePluralResolvers();
  final silentTalker = Talker(settings: TalkerSettings(useConsoleLogs: false));

  await tester.pumpWidget(
    TranslationProvider(
      child: MainApp(
        talker: silentTalker,
        router: buildRouter(talker: silentTalker),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the entrypoint moves on to home by itself', (tester) async {
    await openTheApp(tester);
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('home opens the phase selection, which lists every phase', (tester) async {
    await openTheApp(tester);

    await tester.tap(find.text(t.home.playButton));
    await tester.pumpAndSettle();

    expect(find.byType(PhaseSelectionScreen), findsOneWidget);
    for (final phase in allPhases) {
      expect(find.text(phaseNameOf(t, phase)), findsOneWidget);
    }
  });

  testWidgets('choosing a phase opens its game, preparing the first round', (tester) async {
    await openTheApp(tester);
    final phase = allPhases.first;

    await tester.tap(find.text(t.home.playButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text(phaseNameOf(t, phase)));
    await tester.pumpAndSettle();

    expect(find.byType(GameScreen), findsOneWidget);
    expect(find.text(t.game.shop), findsOneWidget);
    expect(find.text(t.game.round(roundNumber: 1, roundCount: phase.roundCount)), findsOneWidget);
  });

  testWidgets('home opens the settings and back returns to home', (tester) async {
    await openTheApp(tester);

    await tester.tap(find.text(t.home.settingsButton));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('back from home does not return to the entrypoint', (tester) async {
    await openTheApp(tester);
    expect(find.byType(BackButton), findsNothing);
  });
}
