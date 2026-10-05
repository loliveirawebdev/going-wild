import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_shadows.dart';
import 'package:going_wild/ui/core/widgets/button.dart';

Future<void> pumpButton(WidgetTester tester, Button button) => tester.pumpWidget(
  MaterialApp(
    home: Scaffold(body: Center(child: button)),
  ),
);

Container bodyOf(WidgetTester tester) => tester
    .widgetList<Container>(find.descendant(of: find.byType(Button), matching: find.byType(Container)))
    .firstWhere((container) => container.decoration is BoxDecoration);

BoxDecoration decorationOf(WidgetTester tester) => bodyOf(tester).decoration! as BoxDecoration;
double sinkOf(WidgetTester tester) => bodyOf(tester).transform!.getTranslation().y;
double elevationOf(WidgetTester tester) => decorationOf(tester).boxShadow!.single.offset.dy;

void main() {
  testWidgets('each variant paints its own fill, and its edge and shadow in the same darker tone', (tester) async {
    for (final variant in ButtonVariant.values) {
      await pumpButton(tester, Button(label: 'Comprar', onPressed: () {}, variant: variant));

      expect(decorationOf(tester).color, variant.background, reason: variant.name);
      expect(decorationOf(tester).boxShadow!.single.color, variant.border, reason: variant.name);
      expect((decorationOf(tester).border! as Border).top.color, variant.border, reason: variant.name);
      expect(elevationOf(tester), AppShadows.pressOffset, reason: variant.name);
    }
  });

  testWidgets('holding the button sinks it while its raised edge contracts, and letting go brings it back', (tester) async {
    var pressCount = 0;
    await pumpButton(tester, Button(label: 'Comprar', onPressed: () => pressCount++));

    final gesture = await tester.startGesture(tester.getCenter(find.text('Comprar')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 20));
    expect(sinkOf(tester), inExclusiveRange(0, AppShadows.pressOffset));
    expect(elevationOf(tester), inExclusiveRange(0, AppShadows.pressOffset));

    await tester.pump(const Duration(milliseconds: 100));
    expect(sinkOf(tester), AppShadows.pressOffset);
    expect(elevationOf(tester), 0);

    await gesture.up();
    await tester.pumpAndSettle();
    expect(sinkOf(tester), 0);
    expect(elevationOf(tester), AppShadows.pressOffset);
    expect(pressCount, 1);
  });

  testWidgets('a quick tap still sinks all the way before coming back', (tester) async {
    await pumpButton(tester, Button(label: 'Comprar', onPressed: () {}));

    await tester.tap(find.text('Comprar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 40));
    expect(sinkOf(tester), AppShadows.pressOffset);

    await tester.pumpAndSettle();
    expect(sinkOf(tester), 0);
  });

  testWidgets('a disabled button turns gray, keeps its shadow and does not sink', (tester) async {
    await pumpButton(tester, const Button(label: 'Comprar', onPressed: null));

    expect(decorationOf(tester).color, AppColors.disabled);
    expect(decorationOf(tester).boxShadow!.single.color, AppColors.disabledShadow);

    final gesture = await tester.startGesture(tester.getCenter(find.text('Comprar')));
    await tester.pump();
    expect(sinkOf(tester), 0);
    await gesture.up();
  });

  testWidgets('a tap on a disabled button with a reason shows the reason for a moment', (tester) async {
    await pumpButton(tester, const Button(label: 'Comprar', onPressed: null, disabledReason: 'Moedas insuficientes'));
    expect(find.text('Moedas insuficientes'), findsNothing);

    await tester.tap(find.text('Comprar'));
    await tester.pump();
    expect(find.text('Moedas insuficientes'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1800));
    expect(find.text('Moedas insuficientes'), findsNothing);
  });

  testWidgets('the reason stays inside the screen when the button sits at the edge', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomLeft,
            child: Button(label: 'Ok', onPressed: null, disabledReason: 'Time cheio para o seu nível'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Ok'));
    await tester.pump();

    final screenWidth = tester.view.physicalSize.width / tester.view.devicePixelRatio;
    final bubbleRect = tester.getRect(find.text('Time cheio para o seu nível'));

    expect(bubbleRect.left, greaterThan(0));
    expect(bubbleRect.right, lessThan(screenWidth));
  });
}
