import 'package:flutter/material.dart';

import 'app.dart';
import 'generated/i18n/translations.g.dart';
import 'routing/router.dart';
import 'ui/core/localization/configure_plural_resolvers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configurePluralResolvers();
  LocaleSettings.useDeviceLocale();
  runApp(TranslationProvider(child: MainApp(router: buildRouter())));
}
