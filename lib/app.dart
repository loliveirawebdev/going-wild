import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'generated/i18n/translations.g.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.talker, required this.router});

  final Talker talker;
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: talker,
      child: MaterialApp.router(
        routerConfig: router,
        locale: TranslationProvider.of(context).flutterLocale,
        supportedLocales: AppLocaleUtils.supportedLocales,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        onGenerateTitle: (context) => context.t.app.title,
      ),
    );
  }
}
