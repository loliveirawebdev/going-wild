import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_theme.dart';
import 'package:talker_flutter/talker_flutter.dart';

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
        theme: AppTheme.day(),
        onGenerateTitle: (context) => context.t.app.title,
        supportedLocales: AppLocaleUtils.supportedLocales,
        locale: TranslationProvider.of(context).flutterLocale,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
      ),
    );
  }
}
