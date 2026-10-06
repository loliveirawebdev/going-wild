import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/app.dart';
import 'package:going_wild/content/phase/phases.dart';
import 'package:going_wild/data/repositories/match_repository.dart';
import 'package:going_wild/data/repositories/settings_repository.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/routing/router.dart';
import 'package:going_wild/routing/routes.dart';
import 'package:going_wild/ui/core/localization/configure_plural_resolvers.dart';
import 'package:going_wild/ui/core/localization/phase_name.dart';
import 'package:going_wild/ui/game/widgets/game_screen.dart';
import 'package:going_wild/ui/home/widgets/home_screen.dart';
import 'package:going_wild/ui/phase_selection/widgets/phase_page_dots.dart';
import 'package:going_wild/ui/phase_selection/widgets/phase_selection_screen.dart';
import 'package:going_wild/ui/settings/widgets/settings_screen.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../helpers/in_memory_local_storage.dart';

Future<void> openTheApp(WidgetTester tester) async {
  configurePluralResolvers();
  final silentTalker = Talker(settings: TalkerSettings(useConsoleLogs: false));

  await tester.pumpWidget(
    TranslationProvider(
      child: MainApp(
        talker: silentTalker,
        router: buildRouter(talker: silentTalker),
        settingsRepository: SettingsRepository(localStorage: InMemoryLocalStorage()),
      ),
    ),
  );

  for (var attempt = 0; attempt < 400 && find.byType(HomeScreen).evaluate().isEmpty; attempt++) {
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 10)));
    await tester.pump(const Duration(milliseconds: 16));
  }

  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the entrypoint moves on to home by itself', (tester) async {
    await openTheApp(tester);
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('home opens the phase selection, centered on the first phase with a dot per phase', (tester) async {
    await openTheApp(tester);

    await tester.tap(find.text(t.home.playButton));
    await tester.pumpAndSettle();

    expect(find.byType(PhaseSelectionScreen), findsOneWidget);
    expect(find.text(phaseNameOf(t, allPhases.first)), findsOneWidget);
    expect(tester.widget<PhasePageDots>(find.byType(PhasePageDots)).count, allPhases.length);
  });

  testWidgets('choosing a phase opens its game', (tester) async {
    await openTheApp(tester);

    await tester.tap(find.text(t.home.playButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text(t.phaseSelection.playButton));
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(GameScreen), findsOneWidget);
  });

  testWidgets('the system back inside a match asks before leaving and only leaves after confirming', (tester) async {
    await openTheApp(tester);
    await tester.tap(find.text(t.home.playButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text(t.phaseSelection.playButton));
    await tester.pump(const Duration(seconds: 1));

    await tester.binding.handlePopRoute();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text(t.game.exitDialog.title), findsOneWidget);

    await tester.tap(find.text(t.game.exitDialog.continueButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text(t.game.exitDialog.title), findsNothing);
    expect(find.byType(GameScreen), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text(t.game.exitDialog.exitButton));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(GameScreen), findsNothing);
    expect(find.byType(PhaseSelectionScreen), findsOneWidget);
  });

  testWidgets('home opens the settings and back returns to home', (tester) async {
    await openTheApp(tester);

    await tester.tap(find.bySemanticsLabel(t.home.settingsButton));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);

    await tester.tap(find.bySemanticsLabel(t.settings.backButton));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('back from home does not return to the entrypoint', (tester) async {
    await openTheApp(tester);
    expect(find.byType(BackButton), findsNothing);
  });

  testWidgets('trying a phase again starts a fresh match instead of reusing the old one', (tester) async {
    await openTheApp(tester);
    await tester.tap(find.text(t.home.playButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text(t.phaseSelection.playButton));
    await tester.pump(const Duration(seconds: 1));

    final gameContext = tester.element(find.byType(GameScreen));
    final firstMatchRepository = gameContext.read<MatchRepository>();

    unawaited(GoRouter.of(gameContext).pushReplacement(Routes.gameOf(allPhases.first.id)));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(GameScreen), findsOneWidget);
    expect(tester.element(find.byType(GameScreen)).read<MatchRepository>(), isNot(same(firstMatchRepository)));
  });
}
