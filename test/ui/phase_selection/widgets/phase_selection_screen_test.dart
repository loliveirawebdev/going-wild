import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:going_wild/content/phase/phases.dart';
import 'package:going_wild/data/repositories/progress_repository.dart';
import 'package:going_wild/domain/models/phase/phase_id.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/routing/routes.dart';
import 'package:going_wild/ui/phase_selection/widgets/phase_card.dart';
import 'package:going_wild/ui/phase_selection/widgets/phase_selection_screen.dart';
import 'package:going_wild/ui/progress/view_models/phase_progress_view_model.dart';

import '../../../helpers/in_memory_local_storage.dart';

Future<void> showPhaseSelection(WidgetTester tester, {List<PhaseId> wonPhaseIds = const []}) async {
  tester.view.physicalSize = const Size(402, 874) * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  final progressViewModel = PhaseProgressViewModel(progressRepository: ProgressRepository(localStorage: InMemoryLocalStorage()));
  for (final phaseId in wonPhaseIds) {
    await tester.runAsync(() => progressViewModel.markPhaseWon(phaseId));
  }

  await tester.pumpWidget(
    TranslationProvider(
      child: BlocProvider.value(
        value: progressViewModel,
        child: MaterialApp.router(
          routerConfig: GoRouter(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const Scaffold(body: PhaseSelectionScreen()),
              ),
              GoRoute(path: Routes.game, builder: (context, state) => Text('jogo ${state.pathParameters['phaseId']}')),
            ],
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

PhaseCard cardNamed(WidgetTester tester, String name) =>
    tester.widget<PhaseCard>(find.byWidgetPredicate((widget) => widget is PhaseCard && widget.name == name));

void main() {
  testWidgets('without progress only the backyard can be played and the next phase tells what unlocks it', (tester) async {
    await showPhaseSelection(tester);

    expect(cardNamed(tester, 'Quintal').status, PhaseCardStatus.open);
    expect(cardNamed(tester, 'Beira do Brejo').status, PhaseCardStatus.locked);
    expect(find.text('Vença Quintal para liberar'), findsOneWidget);

    await tester.drag(find.byType(PageView), const Offset(-300, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Jogar'));
    await tester.pumpAndSettle();

    expect(find.text('jogo pond_edge'), findsNothing);
  });

  testWidgets('after winning the backyard it shows a trophy and the selection opens on the next phase, ready to play', (tester) async {
    await showPhaseSelection(tester, wonPhaseIds: [backyard.id]);

    expect(cardNamed(tester, 'Quintal').status, PhaseCardStatus.won);
    expect(cardNamed(tester, 'Beira do Brejo').status, PhaseCardStatus.open);

    await tester.tap(find.text('Jogar'));
    await tester.pumpAndSettle();

    expect(find.text('jogo pond_edge'), findsOneWidget);
  });
}
