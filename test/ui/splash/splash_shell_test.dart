import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:going_wild/data/repositories/progress_repository.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/routing/routes.dart';
import 'package:going_wild/ui/entrypoint/view_models/default_entrypoint_view_model.dart';
import 'package:going_wild/ui/entrypoint/view_models/entrypoint_view_model.dart';
import 'package:going_wild/ui/entrypoint/widgets/entrypoint_screen.dart';
import 'package:going_wild/ui/entrypoint/widgets/loading_panel.dart';
import 'package:going_wild/ui/home/home_route.dart';
import 'package:going_wild/ui/phase_selection/phase_selection_route.dart';
import 'package:going_wild/ui/progress/view_models/phase_progress_view_model.dart';
import 'package:going_wild/ui/splash/widgets/splash_scene.dart';

import '../../helpers/in_memory_local_storage.dart';

GoRouter splashRouter() => GoRouter(
  initialLocation: Routes.entrypoint,
  routes: [
    ShellRoute(
      builder: (context, state, child) => Scaffold(
        body: SplashScene(isBlurred: state.uri.path == Routes.phaseSelection, child: child),
      ),
      routes: [
        GoRoute(
          path: Routes.entrypoint,
          pageBuilder: (context, state) => NoTransitionPage(
            child: BlocProvider<EntrypointViewModel>(
              create: (context) => DefaultEntrypointViewModel(),
              child: EntrypointScreen(loadingStepsOf: (context) => [() async {}]),
            ),
          ),
        ),
        homeRoute,
        phaseSelectionRoute,
      ],
    ),
    GoRoute(path: Routes.settings, builder: (context, state) => const Text('settings')),
    GoRoute(path: Routes.game, builder: (context, state) => Text('game ${state.pathParameters['phaseId']}')),
  ],
);

Future<void> pumpSplash(WidgetTester tester) async {
  await tester.pumpWidget(
    TranslationProvider(
      child: BlocProvider(
        create: (context) => PhaseProgressViewModel(progressRepository: ProgressRepository(localStorage: InMemoryLocalStorage())),
        child: MaterialApp.router(routerConfig: splashRouter()),
      ),
    ),
  );
}

void main() {
  testWidgets('loading moves on to the home inside the same scene, which is never rebuilt', (tester) async {
    await pumpSplash(tester);
    final sceneBeforeLoading = tester.element(find.byType(SplashScene));
    expect(find.text('Preparando a fazenda…'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Preparando a fazenda…'), findsNothing);
    expect(find.text('Jogar'), findsOneWidget);
    expect(tester.element(find.byType(SplashScene)), same(sceneBeforeLoading));
  });

  testWidgets('the play button opens the phase selection, back returns home and the gear opens the settings', (tester) async {
    await pumpSplash(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Jogar'));
    await tester.pumpAndSettle();
    expect(find.text('Escolha a fase'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Voltar'));
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Configurações'));
    await tester.pumpAndSettle();
    expect(find.text('settings'), findsOneWidget);
  });

  testWidgets('the loading bar fills the share of the track that the progress reached', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: LoadingPanel(tip: 'Dica', tipLabel: 'Dica:', loadingLabel: 'Carregando', progressPercentage: 64),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));

    final filledSize = tester.getSize(find.byType(AnimatedContainer));
    expect(filledSize.height, greaterThan(0));
    expect(filledSize.width, greaterThan(100));
  });

  testWidgets('the phase selection blurs the same scene and its play button opens the selected phase', (tester) async {
    await pumpSplash(tester);
    await tester.pumpAndSettle();
    final sceneAtHome = tester.element(find.byType(SplashScene));
    expect(tester.widget<SplashScene>(find.byType(SplashScene)).isBlurred, isFalse);

    await tester.tap(find.text('Jogar'));
    await tester.pumpAndSettle();

    expect(tester.element(find.byType(SplashScene)), same(sceneAtHome));
    expect(tester.widget<SplashScene>(find.byType(SplashScene)).isBlurred, isTrue);
    expect(find.text('Fase 1'), findsOneWidget);
    expect(find.text('Quintal'), findsOneWidget);

    await tester.tap(find.text('Jogar'));
    await tester.pumpAndSettle();
    expect(find.text('game backyard'), findsOneWidget);
  });
}
