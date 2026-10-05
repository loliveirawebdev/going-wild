import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/phase/backyard/backyard.dart';
import 'package:going_wild/data/repositories/match_repository.dart';
import 'package:going_wild/domain/models/board/placement.dart';
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
const fieldDog = CharacterCopy(stars: 1, character: dog);
const fieldSheep = CharacterCopy(stars: 1, character: sheep);

Future<MatchRepository> showGameScreen(WidgetTester tester, {List<Placement> placements = const []}) async {
  tester.view.physicalSize = screenSize * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  final startingMatchProgress = startMatch(backyard, randomGenerator: Random(1));
  final inventory = startingMatchProgress.playerRoster.inventory.createCopyWithEntryAt(0, benchCat);
  final matchRepository = MatchRepository()
    ..replaceMatchProgress(
      startingMatchProgress.createCopyWith(
        playerRoster: startingMatchProgress.playerRoster.createCopyWith(inventory: inventory, placements: placements),
      ),
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

Future<void> dragFromBenchTo(WidgetTester tester, Offset target) =>
    dragBetween(tester, from: tester.getCenter(find.bySemanticsLabel('Banco 1: Gato, 1 estrela')), to: target);

Future<void> dragBetween(WidgetTester tester, {required Offset from, required Offset to}) async {
  final gesture = await tester.startGesture(from);
  await gesture.moveBy(const Offset(0, -20));
  await tester.pump();
  await gesture.moveTo(to);
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

  testWidgets('an animal on the field moves to another free cell of the team', (tester) async {
    const from = Position(row: 6, column: 1);
    const to = Position(row: 5, column: 2);
    final matchRepository = await showGameScreen(
      tester,
      placements: [const Placement(position: from, characterCopy: fieldDog)],
    );

    await dragBetween(tester, from: cellCenterOf(from), to: cellCenterOf(to));

    expect(matchRepository.currentMatchProgress!.playerRoster.placements.single.position, to);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('dropping an animal of the field on another one swaps their cells', (tester) async {
    const dogPosition = Position(row: 6, column: 1);
    const sheepPosition = Position(row: 6, column: 2);
    final matchRepository = await showGameScreen(
      tester,
      placements: [
        const Placement(position: dogPosition, characterCopy: fieldDog),
        const Placement(position: sheepPosition, characterCopy: fieldSheep),
      ],
    );

    await dragBetween(tester, from: cellCenterOf(dogPosition), to: cellCenterOf(sheepPosition));

    final placements = matchRepository.currentMatchProgress!.playerRoster.placements;
    expect(placements.firstWhere((placement) => placement.characterCopy == fieldDog).position, sheepPosition);
    expect(placements.firstWhere((placement) => placement.characterCopy == fieldSheep).position, dogPosition);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('an animal of the field dropped on the bench goes back to it', (tester) async {
    const from = Position(row: 6, column: 1);
    final matchRepository = await showGameScreen(
      tester,
      placements: [const Placement(position: from, characterCopy: fieldDog)],
    );

    await dragBetween(tester, from: cellCenterOf(from), to: tester.getCenter(find.bySemanticsLabel('Banco 3: vazio')));

    final roster = matchRepository.currentMatchProgress!.playerRoster;
    expect(roster.placements, isEmpty);
    expect(roster.inventory.entries, contains(fieldDog));

    await tester.pumpWidget(const SizedBox());
  });
}
