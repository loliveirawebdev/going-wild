import 'package:flutter/material.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translations = context.t;

    return Scaffold(
      appBar: AppBar(title: Text(translations.settings.title)),
      body: Center(child: Text(translations.settings.placeholder)),
    );
  }
}
