import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/configure_plural_resolvers.dart';
import 'package:going_wild/ui/game/widgets/phase_result/phase_result_panel.dart';

Future<({List<String> taps})> showPanel(WidgetTester tester, {required bool isVictory}) async {
  final taps = <String>[];

  await tester.pumpWidget(
    TranslationProvider(
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: PhaseResultPanel(
              lives: isVictory ? 2 : 0,
              maxLives: 3,
              roundCount: 10,
              phaseNumber: 1,
              isVictory: isVictory,
              phaseName: 'Quintal',
              roundsReached: isVictory ? 10 : 7,
              onBack: () => taps.add('back'),
              onRetry: () => taps.add('retry'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();

  return (taps: taps);
}

void main() {
  setUpAll(configurePluralResolvers);

  testWidgets('a cleared phase shows the rounds, the lives left and only the continue button', (tester) async {
    final (:taps) = await showPanel(tester, isVictory: true);

    expect(find.text('Fase vencida!'), findsOneWidget);
    expect(find.text('10/10'), findsOneWidget);
    expect(find.text('RODADAS'), findsOneWidget);
    expect(find.text('VIDAS'), findsOneWidget);
    expect(find.text('Tentar de novo'), findsNothing);

    await tester.tap(find.text('Continuar'));
    expect(taps, ['back']);
  });

  testWidgets('a lost phase encourages another try and offers retry or going back', (tester) async {
    final (:taps) = await showPanel(tester, isVictory: false);

    expect(find.text('Fase perdida'), findsOneWidget);
    expect(find.text('7/10'), findsOneWidget);
    expect(find.textContaining('Monte outro time'), findsOneWidget);

    await tester.tap(find.text('Tentar de novo'));
    await tester.tap(find.text('Voltar às fases'));
    expect(taps, ['retry', 'back']);
  });
}
