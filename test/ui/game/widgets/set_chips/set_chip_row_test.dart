import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/phase/backyard/backyard.dart';
import 'package:going_wild/content/set/sets.dart';
import 'package:going_wild/data/repositories/match_repository.dart';
import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/use_cases/round/start_match.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/preparation_started.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/widgets/set_chips/set_chip.dart';
import 'package:going_wild/ui/game/widgets/set_chips/set_chip_row.dart';

const teamPositions = [
  Position(row: 6, column: 0),
  Position(row: 6, column: 1),
  Position(row: 6, column: 2),
  Position(row: 6, column: 3),
  Position(row: 5, column: 0),
  Position(row: 5, column: 1),
];

Future<void> showSetChipRow(WidgetTester tester, {required List<Character> boardCharacters}) async {
  final startingMatchProgress = startMatch(backyard, randomGenerator: Random(1));
  final placements = [
    for (var index = 0; index < boardCharacters.length; index++)
      Placement(
        position: teamPositions[index],
        characterCopy: CharacterCopy(stars: 1, character: boardCharacters[index]),
      ),
  ];
  final matchRepository = MatchRepository()
    ..replaceMatchProgress(
      startingMatchProgress.createCopyWith(playerRoster: startingMatchProgress.playerRoster.createCopyWith(placements: placements)),
    );

  await tester.pumpWidget(
    TranslationProvider(
      child: MaterialApp(
        home: BlocProvider(
          create: (context) => PreparationBloc(matchRepository: matchRepository)..add(const PreparationStarted()),
          child: const Scaffold(body: SetChipRow()),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
}

void main() {
  testWidgets('shows nothing while no animal is on the field', (tester) async {
    await showSetChipRow(tester, boardCharacters: []);

    expect(find.byType(SetChip), findsNothing);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('shows every set with a member on the field, complete first, then by level and by count', (tester) async {
    await showSetChipRow(tester, boardCharacters: [chicken, rooster, duck, queenBee, dog, sheep]);

    final shownSets = tester.widgetList<SetChip>(find.byType(SetChip)).map((chip) => chip.setPresence.set);

    expect(shownSets, [flyers, herding, guardians, producers, dayAndNight, pets]);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('each chip reads its set, count, next tier and level', (tester) async {
    await showSetChipRow(tester, boardCharacters: [chicken, rooster, duck, queenBee, dog, sheep]);

    expect(find.bySemanticsLabel('Voadores: 4, completo'), findsOneWidget);
    expect(find.bySemanticsLabel('Guardiões: 2 de 4, nível 1'), findsOneWidget);
    expect(find.bySemanticsLabel('Pets: 1 de 2, inativo'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('tapping a set opens its dialog', (tester) async {
    await showSetChipRow(tester, boardCharacters: [dog, sheep]);

    await tester.tap(find.bySemanticsLabel('Pastoreio: 2, completo'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('QUEM ATIVA'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });
}
