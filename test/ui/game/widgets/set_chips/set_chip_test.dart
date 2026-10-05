import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/set/sets.dart';
import 'package:going_wild/domain/models/set/set_presence.dart';
import 'package:going_wild/ui/game/widgets/set_chips/celebration/set_chip_celebration.dart';
import 'package:going_wild/ui/game/widgets/set_chips/celebration/set_chip_shine.dart';
import 'package:going_wild/ui/game/widgets/set_chips/set_chip.dart';

SetChip flyersChipWith({required int presentMemberCount, VoidCallback? onPressed}) => SetChip(
  onPressed: onPressed,
  semanticLabel: 'Voadores',
  setPresence: SetPresence(set: flyers, presentMembers: flyers.members.take(presentMemberCount).toList()),
);

Future<void> showChip(WidgetTester tester, SetChip chip, {bool disablesAnimations = false}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: disablesAnimations),
        child: Scaffold(body: Center(child: chip)),
      ),
    ),
  );
}

void main() {
  testWidgets('only a complete set celebrates', (tester) async {
    await showChip(tester, flyersChipWith(presentMemberCount: 3));
    expect(find.byType(SetChipCelebration), findsNothing);

    await showChip(tester, flyersChipWith(presentMemberCount: 4));
    await tester.pump(const Duration(milliseconds: 1200));
    expect(find.byType(SetChipCelebration), findsOneWidget);
    expect(find.byType(SetChipShine), findsOneWidget);
  });

  testWidgets('with reduced motion the celebration stands still and has no shine', (tester) async {
    await showChip(tester, flyersChipWith(presentMemberCount: 4), disablesAnimations: true);
    await tester.pumpAndSettle();

    expect(find.byType(SetChipCelebration), findsOneWidget);
    expect(find.byType(SetChipShine), findsNothing);
  });

  testWidgets('a tap answers and the chip reads its label', (tester) async {
    var tapCount = 0;
    await showChip(tester, flyersChipWith(presentMemberCount: 3, onPressed: () => tapCount++));

    await tester.tap(find.bySemanticsLabel('Voadores'));
    await tester.pump(const Duration(milliseconds: 200));

    expect(tapCount, 1);
  });
}
