import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../generated/i18n/translations.g.dart';
import '../../../routing/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translations = context.t;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            Text(translations.app.title, style: Theme.of(context).textTheme.headlineLarge),
            FilledButton(onPressed: () => context.push(Routes.phaseSelection), child: Text(translations.home.playButton)),
            OutlinedButton(onPressed: () => context.push(Routes.settings), child: Text(translations.home.settingsButton)),
          ],
        ),
      ),
    );
  }
}
