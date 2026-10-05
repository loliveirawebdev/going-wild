import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:going_wild/content/phase/backyard/backyard.dart';
import 'package:going_wild/data/repositories/match_repository.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/match_progress/round_stage.dart';
import 'package:going_wild/domain/models/player/player.dart';
import 'package:going_wild/domain/use_cases/round/start_match.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/preparation_started.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/widgets/match_top_bar/lives_counter.dart';
import 'package:going_wild/ui/game/widgets/match_top_bar/match_top_bar.dart';

const phaseSelectionText = 'Escolha da fase';

Future<MatchRepository> openMatchTopBar(WidgetTester tester) async {
  final matchRepository = MatchRepository()..replaceMatchProgress(startMatch(backyard, randomGenerator: Random(1)));

  await tester.pumpWidget(
    TranslationProvider(
      child: MaterialApp.router(
        routerConfig: GoRouter(
          initialLocation: '/phase-selection',
          routes: [
            GoRoute(path: '/phase-selection', builder: (context, state) => const Text(phaseSelectionText)),
            GoRoute(
              path: '/game',
              builder: (context, state) => BlocProvider(
                create: (context) => PreparationBloc(matchRepository: matchRepository)..add(const PreparationStarted()),
                child: const Scaffold(body: MatchTopBar()),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  unawaited(GoRouter.of(tester.element(find.text(phaseSelectionText))).push('/game'));
  await tester.pumpAndSettle();

  return matchRepository;
}

MatchProgress currentMatchProgressOf(MatchRepository matchRepository) => matchRepository.currentMatchProgress!;

void main() {
  testWidgets('shows the lives, the round and the preparing stage of the match', (tester) async {
    await openMatchTopBar(tester);

    final livesCounter = tester.widget<LivesCounter>(find.byType(LivesCounter));
    expect(livesCounter.lives, 3);
    expect(livesCounter.maxLives, 3);
    expect(find.text('RODADA'), findsOneWidget);
    expect(find.text('1/${backyard.roundCount}'), findsOneWidget);
    expect(find.text('PREPARAÇÃO'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('follows the match when a life is lost and the fight starts', (tester) async {
    final matchRepository = await openMatchTopBar(tester);
    final matchProgress = currentMatchProgressOf(matchRepository);

    matchRepository.replaceMatchProgress(
      matchProgress.createCopyWith(
        roundStage: RoundStage.fighting,
        player: Player(coins: matchProgress.player.coins, remainingLives: 1),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.widget<LivesCounter>(find.byType(LivesCounter)).lives, 1);
    expect(find.text('COMBATE'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('exit asks first, continue stays in the match and leaving goes back to the phase selection', (tester) async {
    await openMatchTopBar(tester);

    await tester.tap(find.bySemanticsLabel('Sair da partida'));
    await tester.pumpAndSettle();
    expect(find.text('Sair da partida?'), findsOneWidget);

    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(find.byType(MatchTopBar), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Sair da partida'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sair'));
    await tester.pumpAndSettle();

    expect(find.byType(MatchTopBar), findsNothing);
    expect(find.text(phaseSelectionText), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });
}
