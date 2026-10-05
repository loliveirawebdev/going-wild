import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/phase/backyard/backyard.dart';
import 'package:going_wild/data/repositories/match_repository.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/use_cases/round/start_match.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/configure_plural_resolvers.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/preparation_started.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/view_models/roster_drag/roster_drag_view_model.dart';
import 'package:going_wild/ui/game/widgets/board_scene/board_scene_layout.dart';
import 'package:going_wild/ui/game/widgets/game_screen.dart';
import 'package:going_wild/ui/game/widgets/match_field/field_unit_token.dart';

const screenSize = Size(402, 874);
const benchCat = CharacterCopy(stars: 1, character: cat);

Future<MatchRepository> showGameScreen(WidgetTester tester) async {
  tester.view.physicalSize = screenSize * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  final startingMatchProgress = startMatch(backyard, randomGenerator: Random(1));
  final inventory = startingMatchProgress.playerRoster.inventory.createCopyWithEntryAt(0, benchCat);
  final matchRepository = MatchRepository()
    ..replaceMatchProgress(
      startingMatchProgress.createCopyWith(playerRoster: startingMatchProgress.playerRoster.createCopyWith(inventory: inventory)),
    );

  await tester.pumpWidget(
    TranslationProvider(
      child: MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => RosterDragViewModel()),
            BlocProvider(create: (context) => PreparationBloc(matchRepository: matchRepository)..add(const PreparationStarted())),
          ],
          child: const GameScreen(phase: backyard),
        ),
      ),
    ),
  );
  await tester.pump();

  return matchRepository;
}

Offset cellCenterOf(Position position) {
  final scale = BoardSceneLayout.scaleFor(screenSize.width);
  return BoardSceneLayout.cellRectOf(backyard.engines.combatEngine.board, position, scale: scale).center;
}

Future<void> dragFromBenchTo(WidgetTester tester, Offset target) async {
  final gesture = await tester.startGesture(tester.getCenter(find.bySemanticsLabel('Banco 1: Gato, 1 estrela')));
  await gesture.moveBy(const Offset(0, -20));
  await tester.pump();
  await gesture.moveTo(target);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
  await gesture.up();
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  setUpAll(configurePluralResolvers);

  testWidgets('the predators of the round already stand on their side of the field', (tester) async {
    final matchRepository = await showGameScreen(tester);
    final enemyCount = matchRepository.currentMatchProgress!.currentWave.enemies.length;

    final tokens = tester.widgetList<FieldUnitToken>(find.byType(FieldUnitToken));
    expect(tokens.where((token) => token.side == FieldUnitSide.enemy), hasLength(enemyCount));

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('dragging an animal from the bench to a free cell of the team places it there', (tester) async {
    final matchRepository = await showGameScreen(tester);
    const teamPosition = Position(row: 6, column: 1);

    await dragFromBenchTo(tester, cellCenterOf(teamPosition));

    final matchProgress = matchRepository.currentMatchProgress!;
    expect(matchProgress.playerRoster.placements.single.position, teamPosition);
    expect(matchProgress.playerRoster.inventory.entryAt(0), isNull);
    expect(tester.widgetList<FieldUnitToken>(find.byType(FieldUnitToken)).where((token) => token.side == FieldUnitSide.team), hasLength(1));

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('dropping on the enemy side keeps the animal on the bench and tells why', (tester) async {
    final matchRepository = await showGameScreen(tester);

    await dragFromBenchTo(tester, cellCenterOf(const Position(row: 0, column: 1)));

    expect(matchRepository.currentMatchProgress!.playerRoster.placements, isEmpty);
    expect(find.text('Fora do seu lado do campo'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Fora do seu lado do campo'), findsNothing);

    await tester.pumpWidget(const SizedBox());
  });
}
