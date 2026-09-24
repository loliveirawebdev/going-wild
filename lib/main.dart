import 'package:flutter/material.dart';

import 'app.dart';
import 'config/logging/configure_logging.dart';
import 'generated/i18n/translations.g.dart';
import 'routing/router.dart';
import 'ui/core/localization/configure_plural_resolvers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  configurePluralResolvers();
  LocaleSettings.useDeviceLocale();
  final talker = configureLogging();

  runApp(
    TranslationProvider(
      child: MainApp(
        talker: talker,
        router: buildRouter(talker: talker),
      ),
    ),
  );
}
