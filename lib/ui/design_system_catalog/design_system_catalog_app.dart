import 'package:flutter/material.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_theme.dart';
import 'package:going_wild/ui/design_system_catalog/design_system_catalog_screen.dart';

class DesignSystemCatalogApp extends StatelessWidget {
  const DesignSystemCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TranslationProvider(
      child: MaterialApp(
        theme: AppTheme.day(),
        title: 'Design system',
        home: const DesignSystemCatalogScreen(),
      ),
    );
  }
}
