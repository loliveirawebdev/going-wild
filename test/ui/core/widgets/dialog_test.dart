import 'package:flutter/material.dart' hide Dialog;
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/ui/core/widgets/button.dart';
import 'package:going_wild/ui/core/widgets/dialog.dart';
import 'package:going_wild/ui/core/widgets/round_icon_button.dart';

Future<void> openDialog(WidgetTester tester, {VoidCallback? onConfirmed}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: Button(
              label: 'Abrir',
              onPressed: () => presentDialog<void>(
                context,
                barrierLabel: 'Fechar',
                dialog: Dialog(
                  closeLabel: 'Fechar',
                  title: 'Reiniciar progresso?',
                  body: const Text('Isso não dá para desfazer.'),
                  actions: [Button(label: 'Reiniciar', onPressed: onConfirmed ?? () {})],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.text('Abrir'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('opens with its title, body and actions, and an action answers', (tester) async {
    var confirmationCount = 0;
    await openDialog(tester, onConfirmed: () => confirmationCount++);

    expect(find.text('Reiniciar progresso?'), findsOneWidget);
    expect(find.text('Isso não dá para desfazer.'), findsOneWidget);

    await tester.tap(find.text('Reiniciar'));
    expect(confirmationCount, 1);
  });

  testWidgets('closes on the close button and when tapping outside', (tester) async {
    await openDialog(tester);
    await tester.tap(find.byType(RoundIconButton));
    await tester.pumpAndSettle();
    expect(find.text('Reiniciar progresso?'), findsNothing);

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(find.text('Reiniciar progresso?'), findsNothing);
  });

  testWidgets('its texts are not left without a text style, which shows as a yellow underline', (tester) async {
    await openDialog(tester);

    final titleStyle = DefaultTextStyle.of(tester.element(find.text('Reiniciar progresso?'))).style;
    expect(titleStyle.decoration, isNot(TextDecoration.underline));
  });
}
