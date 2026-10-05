import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_shadows.dart';
import 'package:going_wild/ui/core/design/interface_glyph.dart';
import 'package:going_wild/ui/core/widgets/button.dart';
import 'package:going_wild/ui/core/widgets/round_icon_button.dart';

Future<void> pumpRoundIconButton(WidgetTester tester, RoundIconButton button) => tester.pumpWidget(
  MaterialApp(
    home: Scaffold(body: Center(child: button)),
  ),
);

Container bodyOf(WidgetTester tester) => tester
    .widgetList<Container>(find.descendant(of: find.byType(RoundIconButton), matching: find.byType(Container)))
    .firstWhere((container) => container.decoration is BoxDecoration);

BoxDecoration decorationOf(WidgetTester tester) => bodyOf(tester).decoration! as BoxDecoration;

void main() {
  testWidgets('each variant paints its fill with the edge and shadow in its darker tone', (tester) async {
    for (final variant in [ButtonVariant.secondary, ButtonVariant.primary, ButtonVariant.danger]) {
      await pumpRoundIconButton(
        tester,
        RoundIconButton(label: 'Voltar', glyph: InterfaceGlyph.back, onPressed: () {}, variant: variant),
      );

      expect(decorationOf(tester).color, variant.background, reason: variant.name);
      expect(decorationOf(tester).boxShadow!.single.color, variant.border, reason: variant.name);
      expect((decorationOf(tester).border! as Border).top.color, variant.border, reason: variant.name);
    }
  });

  testWidgets('the medium size is the 48 point touch target and the small one is 36', (tester) async {
    await pumpRoundIconButton(tester, RoundIconButton(label: 'Voltar', glyph: InterfaceGlyph.back, onPressed: () {}));
    expect(tester.getSize(find.byType(Container).first), const Size.square(48));

    await pumpRoundIconButton(
      tester,
      RoundIconButton(label: 'Voltar', glyph: InterfaceGlyph.back, onPressed: () {}, size: RoundIconButtonSize.small),
    );
    expect(tester.getSize(find.byType(Container).first), const Size.square(36));
  });

  testWidgets('a tap runs the action and the button sinks while held', (tester) async {
    var pressCount = 0;
    await pumpRoundIconButton(tester, RoundIconButton(label: 'Voltar', glyph: InterfaceGlyph.back, onPressed: () => pressCount++));

    final gesture = await tester.startGesture(tester.getCenter(find.byType(RoundIconButton)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 40));
    expect(bodyOf(tester).transform!.getTranslation().y, AppShadows.pressOffset);

    await gesture.up();
    await tester.pumpAndSettle();
    expect(pressCount, 1);
    expect(find.bySemanticsLabel('Voltar'), findsOneWidget);
  });

  testWidgets('a disabled button turns gray and a tap shows its reason', (tester) async {
    await pumpRoundIconButton(
      tester,
      const RoundIconButton(label: 'Sair', glyph: InterfaceGlyph.exit, onPressed: null, disabledReason: 'A luta está acontecendo'),
    );

    expect(decorationOf(tester).color, AppColors.disabled);

    await tester.tap(find.byType(RoundIconButton));
    await tester.pump();
    expect(find.text('A luta está acontecendo'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1800));
    expect(find.text('A luta está acontecendo'), findsNothing);
  });
}
