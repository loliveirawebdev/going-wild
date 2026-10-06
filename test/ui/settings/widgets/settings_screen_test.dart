import 'package:flutter/material.dart' hide Slider, Switch;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:going_wild/data/repositories/progress_repository.dart';
import 'package:going_wild/data/repositories/settings_repository.dart';
import 'package:going_wild/domain/models/settings/settings.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/routing/routes.dart';
import 'package:going_wild/ui/core/widgets/switch.dart';
import 'package:going_wild/ui/settings/settings_route.dart';
import 'package:going_wild/ui/progress/view_models/phase_progress_view_model.dart';
import 'package:going_wild/ui/settings/view_models/default_settings_view_model.dart';
import 'package:going_wild/ui/settings/view_models/settings_view_model.dart';

import '../../../helpers/in_memory_local_storage.dart';

Future<SettingsViewModel> openSettings(WidgetTester tester) async {
  final settingsViewModel = DefaultSettingsViewModel(
    settingsRepository: SettingsRepository(localStorage: InMemoryLocalStorage()),
  );

  await tester.pumpWidget(
    TranslationProvider(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SettingsViewModel>.value(value: settingsViewModel),
          BlocProvider(
            create: (context) => PhaseProgressViewModel(progressRepository: ProgressRepository(localStorage: InMemoryLocalStorage())),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: GoRouter(initialLocation: Routes.settings, routes: [settingsRoute]),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  return settingsViewModel;
}

void main() {
  testWidgets('shows every setting with its current value', (tester) async {
    await openSettings(tester);

    expect(find.text('Música'), findsOneWidget);
    expect(find.text('70%'), findsOneWidget);
    expect(find.text('Efeitos sonoros'), findsOneWidget);
    expect(find.text('80%'), findsOneWidget);
    expect(find.text('Vibração'), findsOneWidget);
    expect(find.text('Velocidade do combate'), findsOneWidget);
  });

  testWidgets('picking a speed and turning vibration off change the global settings', (tester) async {
    final settingsViewModel = await openSettings(tester);

    await tester.tap(find.text('4×'));
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(settingsViewModel.state.combatSpeedMultiplier, 4);
    expect(settingsViewModel.state.isVibrationEnabled, isFalse);
  });

  testWidgets('reset asks first, cancel keeps everything and confirming brings the defaults back', (tester) async {
    final settingsViewModel = await openSettings(tester);
    await settingsViewModel.changeCombatSpeed(multiplier: 4);
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text('Reiniciar'), 200, scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('Reiniciar'));
    await tester.pumpAndSettle();
    expect(find.text('Reiniciar progresso?'), findsOneWidget);

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(settingsViewModel.state.combatSpeedMultiplier, 4);

    await tester.tap(find.text('Reiniciar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reiniciar').last);
    await tester.pumpAndSettle();

    expect(find.text('Reiniciar progresso?'), findsNothing);
    expect(settingsViewModel.state, Settings.defaults);
  });

  testWidgets('the about rows open the credits, the privacy policy and the terms', (tester) async {
    await openSettings(tester);

    for (final (row, pageTitle) in [
      ('Créditos', 'Créditos'),
      ('Política de privacidade', 'Privacidade'),
      ('Termos de uso', 'Termos de uso'),
    ]) {
      await tester.ensureVisible(find.text(row));
      await tester.pumpAndSettle();
      await tester.tap(find.text(row));
      await tester.pumpAndSettle();

      expect(find.text(pageTitle), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('Voltar'));
      await tester.pumpAndSettle();
    }
  });
}
