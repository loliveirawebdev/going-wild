import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/ui/design_system_catalog/design_system_catalog_app.dart';

void main() {
  testWidgets('the catalog lists its sections and opens the tokens with colors, text, shapes and spaces', (tester) async {
    await tester.pumpWidget(const DesignSystemCatalogApp());

    await tester.tap(find.text('Tokens'));
    await tester.pumpAndSettle();

    for (final block in ['Cores', 'Texto', 'Formas', 'Espaços']) {
      await tester.scrollUntilVisible(find.text(block), 300, scrollable: find.byType(Scrollable).last);
      expect(find.text(block), findsOneWidget);
    }
  });
}
