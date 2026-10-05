import 'package:flutter/material.dart' hide Dialog;
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/set/sets.dart';
import 'package:going_wild/domain/models/set/set_presence.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/configure_plural_resolvers.dart';
import 'package:going_wild/ui/core/widgets/round_icon_button.dart';
import 'package:going_wild/ui/game/widgets/set_dialog/set_dialog.dart';

Future<void> openSetDialog(WidgetTester tester, SetPresence setPresence) async {
  await tester.pumpWidget(
    TranslationProvider(
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: TextButton(
                onPressed: () => presentSetDialog(context, setPresence: setPresence),
                child: const Text('Abrir'),
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

  testWidgets('shows the set, its status, description, levels and who activates it', (tester) async {
    await openSetDialog(tester, SetPresence(set: flyers, presentMembers: flyers.members.take(3).toList()));

    expect(find.text('Voadores'), findsOneWidget);
    expect(find.textContaining('Nível 1 ativo'), findsOneWidget);
    expect(find.textContaining('falta 1 para o nível 2'), findsOneWidget);
    expect(find.text('NÍVEIS'), findsOneWidget);
    expect(find.text('+15% de dano para os membros do set'), findsOneWidget);
    expect(find.text('ATIVO'), findsOneWidget);
    expect(find.text('QUEM ATIVA'), findsOneWidget);

    await tester.ensureVisible(find.text('Abelha-rainha'));
    await tester.pump();

    expect(find.bySemanticsLabel('Galinha, em campo'), findsOneWidget);
    expect(find.bySemanticsLabel('Abelha-rainha, fora do campo'), findsOneWidget);
  });

  testWidgets('an inactive set says how many members are missing for the first level', (tester) async {
    await openSetDialog(tester, SetPresence(set: pets, presentMembers: [pets.members.first]));

    expect(find.textContaining('Inativo'), findsOneWidget);
    expect(find.textContaining('falta 1 para o nível 1'), findsOneWidget);
    expect(find.text('ATIVO'), findsNothing);
  });

  testWidgets('the close button closes it', (tester) async {
    await openSetDialog(tester, SetPresence(set: flyers, presentMembers: flyers.members.take(3).toList()));

    await tester.tap(find.byType(RoundIconButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('NÍVEIS'), findsNothing);
  });
}
