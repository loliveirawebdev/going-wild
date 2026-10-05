import 'package:flutter/material.dart' hide Slider;
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/ui/core/widgets/slider.dart';

String percentageOrMuted(int value) => value == 0 ? 'Mudo' : '$value%';

Future<List<int>> pumpSlider(WidgetTester tester, {required int value}) async {
  final changes = <int>[];

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Slider(label: 'Música', value: value, onChanged: changes.add, valueLabelOf: percentageOrMuted),
        ),
      ),
    ),
  );

  return changes;
}

void main() {
  testWidgets('shows the label and the value, and the minimum reads as muted', (tester) async {
    await pumpSlider(tester, value: 70);
    expect(find.text('Música'), findsOneWidget);
    expect(find.text('70%'), findsOneWidget);

    await pumpSlider(tester, value: 0);
    expect(find.text('Mudo'), findsOneWidget);
  });

  testWidgets('tapping the ends of the track sets the minimum and the maximum', (tester) async {
    final changes = await pumpSlider(tester, value: 50);
    final track = tester.getRect(find.byType(GestureDetector).last);

    await tester.tapAt(track.centerLeft + const Offset(1, 0));
    await tester.tapAt(track.centerRight - const Offset(1, 0));

    expect(changes, [0, 100]);
  });

  testWidgets('dragging the thumb changes the value as it moves', (tester) async {
    final changes = await pumpSlider(tester, value: 0);
    final track = tester.getRect(find.byType(GestureDetector).last);

    await tester.dragFrom(track.centerLeft + const Offset(15, 0), Offset(track.width / 2, 0));

    expect(changes, isNotEmpty);
    expect(changes.last, inInclusiveRange(45, 55));
  });
}
