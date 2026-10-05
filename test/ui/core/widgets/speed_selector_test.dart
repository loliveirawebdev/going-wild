import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/ui/core/widgets/speed_selector.dart';

void main() {
  testWidgets('shows one, two and four times and a tap picks that speed', (tester) async {
    final changes = <int>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(child: SpeedSelector(multiplier: 1, onChanged: changes.add)),
        ),
      ),
    );

    expect(find.text('1×'), findsOneWidget);
    expect(find.text('2×'), findsOneWidget);
    expect(find.text('4×'), findsOneWidget);

    await tester.tap(find.text('4×'));

    expect(changes, [4]);
  });
}
