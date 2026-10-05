import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/phase/backyard/backyard.dart';
import 'package:going_wild/data/repositories/match_repository.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/player/player.dart';
import 'package:going_wild/domain/use_cases/round/start_match.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/configure_plural_resolvers.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/preparation_started.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/widgets/match_shelves/buy_experience_button.dart';
import 'package:going_wild/ui/game/widgets/match_shelves/match_info_shelf.dart';

Future<MatchRepository> showInfoShelf(WidgetTester tester, {required int coins}) async {
  final startingMatchProgress = startMatch(backyard, randomGenerator: Random(1));
  final matchRepository = MatchRepository()
    ..replaceMatchProgress(
      startingMatchProgress.createCopyWith(
        player: Player(coins: coins, remainingLives: startingMatchProgress.player.remainingLives),
      ),
    );

  await tester.pumpWidget(
    TranslationProvider(
      child: MaterialApp(
        home: BlocProvider(
          create: (context) => PreparationBloc(matchRepository: matchRepository)..add(const PreparationStarted()),
          child: const Scaffold(body: Center(child: MatchInfoShelf())),
        ),
      ),
    ),
  );
  await tester.pump();

  return matchRepository;
}

MatchProgress currentMatchProgressOf(MatchRepository matchRepository) => matchRepository.currentMatchProgress!;

void main() {
  setUpAll(configurePluralResolvers);

  testWidgets('shows the level, the experience and the coins', (tester) async {
    final matchRepository = await showInfoShelf(tester, coins: 10);
    final levelProgress = currentMatchProgressOf(matchRepository).playerLevelProgress;

    expect(find.text('${levelProgress.level.number}'), findsOneWidget);
    expect(find.text('XP ${levelProgress.experience}/${levelProgress.level.experienceToNextLevel}'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
    expect(find.text('0/${levelProgress.level.teamSize}'), findsOneWidget);
    expect(find.bySemanticsLabel('0 de ${levelProgress.level.teamSize} bichos no campo'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('buying experience spends coins and fills the bar', (tester) async {
    final matchRepository = await showInfoShelf(tester, coins: 10);
    final experienceBefore = currentMatchProgressOf(matchRepository).playerLevelProgress.experience;

    await tester.tap(find.byType(BuyExperienceButton));
    await tester.pump(const Duration(milliseconds: 400));

    final matchProgress = currentMatchProgressOf(matchRepository);
    expect(matchProgress.player.coins, lessThan(10));
    expect(
      matchProgress.playerLevelProgress.experience != experienceBefore || matchProgress.playerLevelProgress.level.number > 1,
      isTrue,
    );

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('without coins the button is off and tells why', (tester) async {
    await showInfoShelf(tester, coins: 0);

    final button = tester.widget<BuyExperienceButton>(find.byType(BuyExperienceButton));
    expect(button.onPressed, isNull);
    expect(button.disabledReason, 'Moedas insuficientes');

    await tester.pumpWidget(const SizedBox());
  });
}
