import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:going_wild/app.dart';
import 'package:going_wild/config/logging/configure_logging.dart';
import 'package:going_wild/data/repositories/progress_repository.dart';
import 'package:going_wild/data/repositories/settings_repository.dart';
import 'package:going_wild/data/services/local_storage/shared_preferences_local_storage.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/routing/router.dart';
import 'package:going_wild/ui/core/localization/configure_plural_resolvers.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  configurePluralResolvers();
  await LocaleSettings.useDeviceLocale();
  final talker = configureLogging();
  final localStorage = SharedPreferencesLocalStorage(preferences: await SharedPreferences.getInstance());

  runApp(
    TranslationProvider(
      child: MainApp(
        talker: talker,
        router: buildRouter(talker: talker),
        settingsRepository: SettingsRepository(localStorage: localStorage),
        progressRepository: ProgressRepository(localStorage: localStorage),
      ),
    ),
  );
}
