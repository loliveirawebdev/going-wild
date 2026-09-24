import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/phase/phases.dart';
import 'package:going_wild/app.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/routing/router.dart';
import 'package:going_wild/ui/core/localization/phase_name.dart';
import 'package:going_wild/ui/game/widgets/game_screen.dart';
import 'package:going_wild/ui/home/widgets/home_screen.dart';
import 'package:going_wild/ui/phase_selection/widgets/phase_selection_screen.dart';
import 'package:going_wild/ui/settings/widgets/settings_screen.dart';

Future<void> openTheApp(WidgetTester tester) async {
  await tester.pumpWidget(TranslationProvider(child: MainApp(router: buildRouter())));
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

  testWidgets('picking a phase opens the game of that phase', (tester) async {
    await openTheApp(tester);
    await tester.tap(find.text(t.home.playButton));
    await tester.pumpAndSettle();

    await tester.tap(find.text(phaseNameOf(t, backyard)));
    await tester.pumpAndSettle();

    expect(tester.widget<GameScreen>(find.byType(GameScreen)).phaseId, backyard.id);
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
