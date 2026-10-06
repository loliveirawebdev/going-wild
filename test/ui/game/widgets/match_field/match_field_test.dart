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
import 'package:going_wild/ui/game/view_models/combat_playback/combat_playback_bloc.dart';
import 'package:going_wild/ui/game/view_models/match_flow/match_flow_bloc.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/preparation_started.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/view_models/roster_drag/roster_drag_view_model.dart';
import 'package:going_wild/ui/game/view_models/round_banner/round_banner_view_model.dart';
import 'package:going_wild/ui/game/widgets/bench/bench_shelf.dart';
import 'package:going_wild/ui/game/widgets/board_scene/board_scene_layout.dart';
import 'package:going_wild/ui/game/widgets/game_screen.dart';
import 'package:going_wild/ui/game/widgets/match_field/drop_target/field_drop_target.dart';
import 'package:going_wild/ui/game/widgets/match_field/match_field.dart';
import 'package:going_wild/ui/game/widgets/match_field/units/field_unit_token.dart';
import 'package:going_wild/ui/game/widgets/summon/summon_poof.dart';

import '../../../../helpers/manual_combat_playback_clock.dart';

const screenSize = Size(402, 874);
const benchCat = CharacterCopy(stars: 1, character: cat);
const fieldDog = CharacterCopy(stars: 1, character: dog);
const fieldSheep = CharacterCopy(stars: 1, character: sheep);

Future<MatchRepository> showGameScreen(
  WidgetTester tester, {
  Size size = screenSize,
  List<Placement> placements = const [],
}) async {
  tester.view.physicalSize = size * 3;
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
            BlocProvider(create: (context) => RoundBannerViewModel()),
            BlocProvider(
              create: (context) => MatchFlowBloc(randomGenerator: Random(1), matchRepository: matchRepository),
            ),
            BlocProvider(create: (context) => CombatPlaybackBloc(clock: ManualCombatPlaybackClock())),
            BlocProvider(create: (context) => PreparationBloc(matchRepository: matchRepository)..add(const PreparationStarted())),
          ],
          child: const GameScreen(phase: backyard),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
  await tester.pump();

  return matchRepository;
}

Offset cellCenterOf(WidgetTester tester, Position position) {
  final field = tester.renderObject<RenderBox>(find.byType(FieldDropTarget));
  final scale = BoardSceneLayout.scaleFor(field.size.width);
  return field.localToGlobal(BoardSceneLayout.cellRectOf(backyard.engines.combatEngine.board, position, scale: scale).center);
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

  testWidgets('dragging an animal from the bench to a free cell of the team places it there in a puff of smoke', (tester) async {
    final matchRepository = await showGameScreen(tester);
    const teamPosition = Position(row: 6, column: 1);

    await dragFromBenchTo(tester, cellCenterOf(tester, teamPosition));

    final matchProgress = matchRepository.currentMatchProgress!;
    expect(matchProgress.playerRoster.placements.single.position, teamPosition);
    expect(matchProgress.playerRoster.inventory.entryAt(0), isNull);
    expect(tester.widgetList<FieldUnitToken>(find.byType(FieldUnitToken)).where((token) => token.side == FieldUnitSide.team), hasLength(1));
    expect(find.descendant(of: find.byType(MatchField), matching: find.byType(SummonPoof)), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(SummonPoof), findsNothing);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('dropping on the enemy side keeps the animal on the bench and tells why', (tester) async {
    final matchRepository = await showGameScreen(tester);

    await dragFromBenchTo(tester, cellCenterOf(tester, const Position(row: 0, column: 1)));

    expect(matchRepository.currentMatchProgress!.playerRoster.placements, isEmpty);
    expect(find.text('Fora do seu lado do campo'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Fora do seu lado do campo'), findsNothing);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('an animal on the field moves to another free cell of the team without smoke', (tester) async {
    const from = Position(row: 6, column: 1);
    const to = Position(row: 5, column: 2);
    final matchRepository = await showGameScreen(
      tester,
      placements: [const Placement(position: from, characterCopy: fieldDog)],
    );

    await dragBetween(tester, from: cellCenterOf(tester, from), to: cellCenterOf(tester, to));

    expect(matchRepository.currentMatchProgress!.playerRoster.placements.single.position, to);
    expect(find.byType(SummonPoof), findsNothing);

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

    await dragBetween(tester, from: cellCenterOf(tester, dogPosition), to: cellCenterOf(tester, sheepPosition));

    final placements = matchRepository.currentMatchProgress!.playerRoster.placements;
    expect(placements.firstWhere((placement) => placement.characterCopy == fieldDog).position, sheepPosition);
    expect(placements.firstWhere((placement) => placement.characterCopy == fieldSheep).position, dogPosition);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('an animal of the field dropped on the bench goes back to it in a puff of smoke', (tester) async {
    const from = Position(row: 6, column: 1);
    final matchRepository = await showGameScreen(
      tester,
      placements: [const Placement(position: from, characterCopy: fieldDog)],
    );

    await dragBetween(tester, from: cellCenterOf(tester, from), to: tester.getCenter(find.bySemanticsLabel('Banco 3: vazio')));

    final roster = matchRepository.currentMatchProgress!.playerRoster;
    expect(roster.placements, isEmpty);
    expect(roster.inventory.entries, contains(fieldDog));
    expect(find.descendant(of: find.byType(BenchShelf), matching: find.byType(SummonPoof)), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('with the bench open, picking an animal on the field closes the bench and still moves it', (tester) async {
    const from = Position(row: 4, column: 1);
    const to = Position(row: 4, column: 2);
    final matchRepository = await showGameScreen(
      tester,
      placements: [const Placement(position: from, characterCopy: fieldDog)],
    );

    await tester.tap(find.bySemanticsLabel('Banco 1: Gato, 1 estrela'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Gato'), findsOneWidget);

    await dragBetween(tester, from: cellCenterOf(tester, from), to: cellCenterOf(tester, to));

    expect(find.text('Gato'), findsNothing);
    expect(matchRepository.currentMatchProgress!.playerRoster.placements.single.position, to);
    expect(find.byType(SummonPoof), findsNothing);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a quick tap on an animal of the field opens its sheet with the sale', (tester) async {
    const position = Position(row: 6, column: 1);
    await showGameScreen(
      tester,
      placements: [const Placement(position: position, characterCopy: fieldDog)],
    );

    await tester.tapAt(cellCenterOf(tester, position));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('SEU TIME'), findsOneWidget);
    expect(find.text('Vender'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the predators of the round arrive in a puff of smoke that goes away by itself', (tester) async {
    final matchRepository = await showGameScreen(tester);
    final enemyCount = matchRepository.currentMatchProgress!.currentWave.enemies.length;

    expect(find.byType(SummonPoof), findsNWidgets(enemyCount));

    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(SummonPoof), findsNothing);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a quick tap on a predator opens its sheet without the sale', (tester) async {
    final matchRepository = await showGameScreen(tester);
    final enemyPosition = matchRepository.currentMatchProgress!.currentWave.enemies.first.position;
    await tester.pump(const Duration(seconds: 1));

    await tester.tapAt(cellCenterOf(tester, enemyPosition));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('INIMIGO'), findsOneWidget);
    expect(find.text('Vender'), findsNothing);

    await tester.pumpWidget(const SizedBox());
  });
}
