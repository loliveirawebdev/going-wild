import 'package:flutter/material.dart';

import '../../../data/phase/phases.dart';
import '../../../generated/i18n/translations.g.dart';
import '../../core/localization/phase_name.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key, required this.phaseId});

  final String phaseId;

  @override
  Widget build(BuildContext context) {
    final translations = context.t;
    final phase = allPhases.firstWhere((phase) => phase.id == phaseId);
    final phaseName = phaseNameOf(translations, phase);

    return Scaffold(
      appBar: AppBar(title: Text(phaseName)),
      body: Center(child: Text(translations.game.placeholder(phaseName: phaseName))),
    );
  }
}
