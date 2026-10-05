import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/phase/backyard/backyard.dart';
import 'package:going_wild/data/repositories/match_repository.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/match_progress/round_stage.dart';
import 'package:going_wild/domain/use_cases/round/start_match.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/configure_plural_resolvers.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/preparation_started.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/widgets/bench/bench_shop_tile.dart';
import 'package:going_wild/ui/game/widgets/bench/bench_slot.dart';
import 'package:going_wild/ui/game/widgets/match_shelves/match_bottom.dart';

const resizeDuration = Duration(milliseconds: 500);

Future<void> finishResizing(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(resizeDuration);
}

Future<MatchRepository> showMatchBottom(WidgetTester tester, {List<CharacterCopy> benchCopies = const []}) async {
  final startingMatchProgress = startMatch(backyard, randomGenerator: Random(1));
  var inventory = startingMatchProgress.playerRoster.inventory;
  for (final (slotIndex, characterCopy) in benchCopies.indexed) {
    inventory = inventory.createCopyWithEntryAt(slotIndex, characterCopy);
  }
  final matchRepository = MatchRepository()
    ..replaceMatchProgress(
      startingMatchProgress.createCopyWith(playerRoster: startingMatchProgress.playerRoster.createCopyWith(inventory: inventory)),
    );

  await tester.pumpWidget(
    TranslationProvider(
      child: MaterialApp(
        home: BlocProvider(
          create: (context) => PreparationBloc(matchRepository: matchRepository)..add(const PreparationStarted()),
          child: const Scaffold(body: MatchBottom()),
        ),
      ),
    ),
  );
  await tester.pump();

  return matchRepository;
}

void main() {
  setUpAll(configurePluralResolvers);

  testWidgets('closed, the bench shows seven small slots without names and the shop button', (tester) async {
    await showMatchBottom(tester, benchCopies: [const CharacterCopy(stars: 2, character: cat)]);

    expect(find.byType(BenchSlot), findsNWidgets(7));
    expect(find.byType(BenchShopTile), findsOneWidget);
    expect(find.text('Gato'), findsNothing);
    expect(find.bySemanticsLabel('Banco 1: Gato, 2 estrelas'), findsOneWidget);
    expect(find.bySemanticsLabel('Banco 2: vazio'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('tapping the bench opens it with names and the handle closes it again', (tester) async {
    await showMatchBottom(tester, benchCopies: [const CharacterCopy(stars: 2, character: cat)]);

    await tester.tap(find.byType(BenchSlot).first);
    await finishResizing(tester);
    expect(find.text('Gato'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Fechar banco'));
    await finishResizing(tester);
    expect(find.text('Gato'), findsNothing);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('dragging the handle up opens it and tapping outside closes it', (tester) async {
    await showMatchBottom(tester, benchCopies: [const CharacterCopy(stars: 2, character: cat)]);

    await tester.fling(find.bySemanticsLabel('Abrir banco'), const Offset(0, -80), 800);
    await finishResizing(tester);
    expect(find.text('Gato'), findsOneWidget);

    await tester.tapAt(const Offset(200, 40));
    await finishResizing(tester);
    expect(find.text('Gato'), findsNothing);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the bench closes when the fight starts', (tester) async {
    final matchRepository = await showMatchBottom(tester, benchCopies: [const CharacterCopy(stars: 2, character: cat)]);

    await tester.tap(find.byType(BenchSlot).first);
    await finishResizing(tester);
    matchRepository.replaceMatchProgress(matchRepository.currentMatchProgress!.createCopyWith(roundStage: RoundStage.fighting));
    await tester.pump();
    await finishResizing(tester);

    expect(find.text('Gato'), findsNothing);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('with the bench open, tapping an animal opens its sheet', (tester) async {
    await showMatchBottom(tester, benchCopies: [const CharacterCopy(stars: 2, character: cat)]);

    await tester.tap(find.byType(BenchSlot).first);
    await finishResizing(tester);
    await tester.tap(find.text('Gato'));
    await finishResizing(tester);

    expect(find.text('SEU TIME'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });
}
