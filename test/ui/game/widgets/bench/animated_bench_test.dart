import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/configure_plural_resolvers.dart';
import 'package:going_wild/ui/game/view_models/roster_drag/roster_drag_view_model.dart';
import 'package:going_wild/ui/game/widgets/bench/animated_bench.dart';

const catCopy = CharacterCopy(stars: 1, character: cat);
const dogCopy = CharacterCopy(stars: 1, character: dog);

Widget benchOf(List<CharacterCopy?> benchCopies, {required void Function(int fromIndex, int toIndex) onCopyMoved}) => TranslationProvider(
  child: MaterialApp(
    home: BlocProvider(
      create: (context) => RosterDragViewModel(),
      child: Scaffold(
        body: Center(
          child: SizedBox(
            width: 380,
            child: AnimatedBench(
              summonIds: const {},
              isExpanded: true,
              canDragCopies: true,
              benchCopies: benchCopies,
              onCopyMoved: onCopyMoved,
              onSlotPressed: (slotIndex, characterCopy) {},
              onSummonFinished: (slotIndex, summonId) {},
              onBoardCopyDropped: (fromPosition, toIndex) {},
            ),
          ),
        ),
      ),
    ),
  ),
);

Future<void> dragSlot(WidgetTester tester, String fromLabel, String toLabel) async {
  final gesture = await tester.startGesture(tester.getCenter(find.bySemanticsLabel(fromLabel)));
  await gesture.moveBy(const Offset(0, -20));
  await tester.pump();
  await gesture.moveTo(tester.getCenter(find.bySemanticsLabel(toLabel)));
  await tester.pump();
  await gesture.up();
  await tester.pump();
}

void main() {
  setUpAll(configurePluralResolvers);

  testWidgets('a move the game refuses leaves every animal where it was', (tester) async {
    final benchCopies = <CharacterCopy?>[catCopy, dogCopy, null, null, null, null, null];
    await tester.pumpWidget(benchOf(benchCopies, onCopyMoved: (fromIndex, toIndex) {}));

    await dragSlot(tester, 'Banco 1: Gato, 1 estrela', 'Banco 2: Cachorro, 1 estrela');
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.bySemanticsLabel('Banco 1: Gato, 1 estrela'), findsOneWidget);
    expect(find.bySemanticsLabel('Banco 2: Cachorro, 1 estrela'), findsOneWidget);
  });

  testWidgets('an accepted swap slides the displaced animal back to where the dragged one came from', (tester) async {
    var benchCopies = <CharacterCopy?>[catCopy, dogCopy, null, null, null, null, null];
    late StateSetter rebuild;
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) {
          rebuild = setState;
          return benchOf(
            benchCopies,
            onCopyMoved: (fromIndex, toIndex) => rebuild(() {
              benchCopies = [...benchCopies]
                ..[toIndex] = benchCopies[fromIndex]
                ..[fromIndex] = benchCopies[toIndex];
            }),
          );
        },
      ),
    );
    final catSlotCenter = tester.getCenter(find.bySemanticsLabel('Banco 1: Gato, 1 estrela'));

    await dragSlot(tester, 'Banco 1: Gato, 1 estrela', 'Banco 2: Cachorro, 1 estrela');
    await tester.pump(const Duration(milliseconds: 60));

    final slidingDogCenter = tester.getCenter(find.bySemanticsLabel('Banco 1: Cachorro, 1 estrela'));
    expect(slidingDogCenter.dx, greaterThan(catSlotCenter.dx));

    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.getCenter(find.bySemanticsLabel('Banco 1: Cachorro, 1 estrela')).dx, closeTo(catSlotCenter.dx, 0.5));
    expect(find.bySemanticsLabel('Banco 2: Gato, 1 estrela'), findsOneWidget);
  });
}
