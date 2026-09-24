import 'package:flutter/material.dart';

import 'app.dart';
import 'generated/i18n/translations.g.dart';
import 'routing/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  runApp(TranslationProvider(child: MainApp(router: buildRouter())));
}
