import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/phase/phases.dart';
import '../../../generated/i18n/translations.g.dart';
import '../../../routing/routes.dart';
import '../../core/localization/phase_name.dart';

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
              subtitle: Text(translations.phaseSelection.roundCount(roundCount: phase.roundCount)),
              onTap: () => context.push(Routes.goToPhaseId(phase.id)),
            ),
        ],
      ),
    );
  }
}
