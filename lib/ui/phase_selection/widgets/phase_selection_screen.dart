import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:going_wild/content/phase/phases.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/routing/routes.dart';
import 'package:going_wild/ui/core/localization/phase_name.dart';

class PhaseSelectionScreen extends StatelessWidget {
  const PhaseSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translations = context.t;

    return Scaffold(
      appBar: AppBar(title: Text(translations.phaseSelection.title)),
      body: ListView(
        children: [
          for (final phase in allPhases)
            ListTile(
              title: Text(phaseNameOf(translations, phase)),
              onTap: () => context.push(Routes.gameOf(phase.id)),
              subtitle: Text(translations.phaseSelection.roundCount(roundCount: phase.roundCount)),
            ),
        ],
      ),
    );
  }
}
