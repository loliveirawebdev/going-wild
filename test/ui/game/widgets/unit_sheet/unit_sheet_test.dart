import 'package:flutter/material.dart' hide Dialog;
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/phase/backyard/backyard.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/configure_plural_resolvers.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_sale.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_sell_button.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_sheet.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_side.dart';

Future<void> openUnitSheet(WidgetTester tester, {required UnitSale sale}) async {
  tester.view.physicalSize = const Size(402 * 3, 874 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    TranslationProvider(
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: TextButton(
                child: const Text('Abrir'),
                onPressed: () => presentUnitSheet(
                  context,
                  sale: sale,
                  side: UnitSide.team,
                  engines: backyard.engines,
                  characterCopy: const CharacterCopy(stars: 2, character: cat),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.text('Abrir'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  setUpAll(configurePluralResolvers);

  testWidgets('shows who the animal is, its sets, role, range, stats and ability', (tester) async {
    await openUnitSheet(tester, sale: UnitSale(valueInCoins: 3, onSell: () {}));

    expect(find.text('Gato'), findsOneWidget);
    expect(find.text('SEU TIME'), findsOneWidget);
    expect(find.text('Pets'), findsOneWidget);
    expect(find.text('Guardiões'), findsOneWidget);
    expect(find.text('Dia e Noite'), findsOneWidget);
    expect(find.text('Dano'), findsWidgets);
    expect(find.text('Corpo a corpo'), findsOneWidget);
    expect(find.text('Vida'), findsOneWidget);
    expect(find.text('Vel. de ataque'), findsOneWidget);
    expect(find.text('Inimigo com menos vida: 300 de dano'), findsOneWidget);
    expect(find.text('+3'), findsOneWidget);
  });

  testWidgets('selling calls the sale and closes the sheet', (tester) async {
    var saleCount = 0;
    await openUnitSheet(tester, sale: UnitSale(valueInCoins: 3, onSell: () => saleCount++));

    await tester.tap(find.byType(UnitSellButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(saleCount, 1);
    expect(find.text('SEU TIME'), findsNothing);
  });

  testWidgets('a sale that cannot happen keeps the button off with its reason', (tester) async {
    await openUnitSheet(tester, sale: const UnitSale(valueInCoins: 3, onSell: null, disabledReason: 'A luta está acontecendo'));

    await tester.tap(find.byType(UnitSellButton));
    await tester.pump();

    expect(find.text('A luta está acontecendo'), findsOneWidget);
    expect(find.text('SEU TIME'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
  });
}
