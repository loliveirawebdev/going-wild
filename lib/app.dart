import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:going_wild/data/repositories/progress_repository.dart';
import 'package:going_wild/data/repositories/settings_repository.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_theme.dart';
import 'package:going_wild/ui/progress/view_models/phase_progress_view_model.dart';
import 'package:going_wild/ui/settings/view_models/default_settings_view_model.dart';
import 'package:going_wild/ui/settings/view_models/settings_view_model.dart';
import 'package:talker_flutter/talker_flutter.dart';

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
    required this.talker,
    required this.router,
    required this.settingsRepository,
    required this.progressRepository,
  });

  final Talker talker;
  final GoRouter router;
  final SettingsRepository settingsRepository;
  final ProgressRepository progressRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: talker),
        RepositoryProvider.value(value: settingsRepository),
        RepositoryProvider.value(value: progressRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SettingsViewModel>(create: (context) => DefaultSettingsViewModel(settingsRepository: settingsRepository)),
          BlocProvider(create: (context) => PhaseProgressViewModel(progressRepository: progressRepository)),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          theme: AppTheme.day(),
          onGenerateTitle: (context) => context.t.app.title,
          supportedLocales: AppLocaleUtils.supportedLocales,
          locale: TranslationProvider.of(context).flutterLocale,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
        ),
      ),
    );
  }
}
