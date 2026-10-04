import 'package:flutter/material.dart';
import 'package:going_wild/app.dart';
import 'package:going_wild/config/logging/configure_logging.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/routing/router.dart';
import 'package:going_wild/ui/core/localization/configure_plural_resolvers.dart';

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
