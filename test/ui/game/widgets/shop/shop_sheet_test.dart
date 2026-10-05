import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/phase/backyard/backyard.dart';
import 'package:going_wild/data/repositories/match_repository.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/match_progress/round_stage.dart';
import 'package:going_wild/domain/models/player/player.dart';
import 'package:going_wild/domain/use_cases/round/start_match.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/configure_plural_resolvers.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/preparation_started.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/widgets/shop/shop_card.dart';
import 'package:going_wild/ui/game/widgets/shop/shop_card_state.dart';
import 'package:going_wild/ui/game/widgets/shop/shop_lock_toggle.dart';
import 'package:going_wild/ui/game/widgets/shop/shop_sheet.dart';

const sheetDuration = Duration(milliseconds: 400);

Future<MatchRepository> openShop(WidgetTester tester, {int coins = 10, RoundStage roundStage = RoundStage.preparing}) async {
  tester.view.physicalSize = const Size(402 * 3, 874 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  final startingMatchProgress = startMatch(backyard, randomGenerator: Random(1));
  final matchRepository = MatchRepository()
    ..replaceMatchProgress(
      startingMatchProgress.createCopyWith(
        roundStage: roundStage,
        player: Player(coins: coins, remainingLives: startingMatchProgress.player.remainingLives),
      ),
    );

  await tester.pumpWidget(
    TranslationProvider(
      child: MaterialApp(
        home: BlocProvider(
          create: (context) => PreparationBloc(matchRepository: matchRepository)..add(const PreparationStarted()),
          child: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: TextButton(onPressed: () => presentShopSheet(context), child: const Text('Abrir')),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.tap(find.text('Abrir'));
  await tester.pump();
  await tester.pump(sheetDuration);

  return matchRepository;
}

MatchProgress currentMatchProgressOf(MatchRepository matchRepository) => matchRepository.currentMatchProgress!;

Future<void> settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(sheetDuration);
}

void main() {
  setUpAll(configurePluralResolvers);

  testWidgets('shows the four offers, the lock, the coins and the reroll button', (tester) async {
    await openShop(tester);

    expect(find.text('Loja'), findsOneWidget);
    expect(find.byType(ShopCard), findsNWidgets(4));
    expect(find.text('Travar loja'), findsOneWidget);
    expect(find.text('Trocar ofertas'), findsOneWidget);
    expect(find.text('Comprar XP'), findsNothing);
  });

  testWidgets('buying an offer spends coins, sends the animal to the bench and keeps it faded and stamped in the open shop', (
    tester,
  ) async {
    final matchRepository = await openShop(tester);

    await tester.tap(find.byType(ShopCard).first);
    await settle(tester);

    final matchProgress = currentMatchProgressOf(matchRepository);
    expect(matchProgress.player.coins, lessThan(10));
    expect(matchProgress.playerRoster.inventory.entries, hasLength(1));
    expect(tester.widgetList<ShopCard>(find.byType(ShopCard)).where((card) => card.state == ShopCardState.sold), hasLength(1));
    expect(find.text('VENDIDO'), findsOneWidget);
    expect(find.text('Loja'), findsOneWidget);
  });

  testWidgets('the lock toggles and rerolling spends coins and unlocks the shop', (tester) async {
    final matchRepository = await openShop(tester);

    await tester.tap(find.byType(ShopLockToggle));
    await settle(tester);
    expect(currentMatchProgressOf(matchRepository).shop.isLocked, isTrue);
    expect(find.text('Destravar loja'), findsOneWidget);

    await tester.tap(find.text('Trocar ofertas'));
    await settle(tester);
    expect(currentMatchProgressOf(matchRepository).shop.isLocked, isFalse);
    expect(currentMatchProgressOf(matchRepository).player.coins, lessThan(10));
  });

  testWidgets('without coins the offers look unaffordable and tell why', (tester) async {
    await openShop(tester, coins: 0);

    final cards = tester.widgetList<ShopCard>(find.byType(ShopCard));
    expect(cards.map((card) => card.state), everyElement(ShopCardState.unaffordable));
    expect(cards.first.disabledReason, 'Moedas insuficientes');
  });

  testWidgets('during the fight every offer is locked', (tester) async {
    await openShop(tester, roundStage: RoundStage.fighting);

    final cards = tester.widgetList<ShopCard>(find.byType(ShopCard));
    expect(cards.map((card) => card.state), everyElement(ShopCardState.locked));
    expect(cards.first.disabledReason, 'A luta está acontecendo');
  });

  testWidgets('the close button closes the shop', (tester) async {
    await openShop(tester);

    await tester.tap(find.bySemanticsLabel('Fechar loja').last);
    await settle(tester);

    expect(find.text('Loja'), findsNothing);
  });
}
