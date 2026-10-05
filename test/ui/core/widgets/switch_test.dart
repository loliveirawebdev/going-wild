import 'package:flutter/material.dart' hide Switch;
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/ui/core/widgets/switch.dart';

void main() {
  testWidgets('a tap on the switch or its label asks for the opposite state', (tester) async {
    final changes = <bool>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Switch(label: 'Vibração', isOn: true, onChanged: changes.add),
        ),
      ),
    );

    await tester.tap(find.text('Vibração'));

    expect(changes, [false]);
  });
}
