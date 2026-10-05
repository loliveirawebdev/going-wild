import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/ui/core/widgets/progress_bar.dart';

Future<void> pumpProgressBar(WidgetTester tester, ProgressBar progressBar) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: SizedBox(width: 200, child: progressBar)),
    ),
  );
  await tester.pumpAndSettle();
}

double filledWidthOf(WidgetTester tester) => tester.getSize(find.byType(DecoratedBox).last).width;
double trackWidthOf(WidgetTester tester) => tester.getSize(find.byType(FractionallySizedBox)).width;

void main() {
  testWidgets('the fill covers the share of the track that the value reaches', (tester) async {
    await pumpProgressBar(tester, const ProgressBar(value: 25));

    expect(filledWidthOf(tester), closeTo(trackWidthOf(tester) * 0.25, 0.5));
  });

  testWidgets('a value outside the range stays between empty and full', (tester) async {
    await pumpProgressBar(tester, const ProgressBar(value: 150));
    expect(filledWidthOf(tester), closeTo(trackWidthOf(tester), 0.5));

    await pumpProgressBar(tester, const ProgressBar(value: -10));
    expect(filledWidthOf(tester), 0);
  });

  testWidgets('the label and the value over the maximum show only when asked', (tester) async {
    await pumpProgressBar(tester, const ProgressBar(value: 640, max: 1000));
    expect(find.text('640 / 1000'), findsNothing);

    await pumpProgressBar(tester, const ProgressBar(value: 640, max: 1000, showsValue: true, label: 'Nível da fazenda'));
    expect(find.text('640 / 1000'), findsOneWidget);
    expect(find.text('Nível da fazenda'), findsOneWidget);
  });
}
