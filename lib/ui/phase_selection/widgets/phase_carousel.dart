import 'package:flutter/widgets.dart';
import 'package:going_wild/content/phase/phases.dart';
import 'package:going_wild/domain/models/phase/phase.dart';
import 'package:going_wild/domain/models/progress/phase_availability.dart';
import 'package:going_wild/domain/models/progress/phase_progress.dart';
import 'package:going_wild/domain/use_cases/progress/phase_availability_of.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/phase_name.dart';
import 'package:going_wild/ui/phase_selection/phase_cover.dart';
import 'package:going_wild/ui/phase_selection/widgets/phase_card.dart';

const _neighborScaleReduction = 0.14;
const _neighborOpacityReduction = 0.3;

class PhaseCarousel extends StatelessWidget {
  const PhaseCarousel({
    required this.phases,
    required this.progress,
    required this.controller,
    required this.selectedIndex,
    required this.onPhaseChanged,
    super.key,
  });

  final List<Phase> phases;
  final PhaseProgress progress;
  final int selectedIndex;
  final PageController controller;
  final ValueChanged<int> onPhaseChanged;

  double _distanceFromCenterOf(int index) {
    final hasMeasuredPages = controller.hasClients && controller.position.haveDimensions;
    final currentPage = hasMeasuredPages ? controller.page! : selectedIndex.toDouble();
    return (currentPage - index).abs().clamp(0, 1).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final translations = context.t;

    return PageView.builder(
      controller: controller,
      itemCount: phases.length,
      onPageChanged: onPhaseChanged,
      itemBuilder: (context, index) => AnimatedBuilder(
        animation: controller,
        builder: (context, card) {
          final distance = _distanceFromCenterOf(index);

          return Opacity(
            opacity: 1 - _neighborOpacityReduction * distance,
            child: Transform.scale(scale: 1 - _neighborScaleReduction * distance, child: card),
          );
        },
        child: Center(
          child: _cardOf(translations, index),
        ),
      ),
    );
  }

  PhaseCard _cardOf(Translations translations, int index) {
    final phase = phases[index];
    final availability = phaseAvailabilityOf(phase, phases: phases, progress: progress);

    return PhaseCard(
      name: phaseNameOf(translations, phase),
      coverAssetPath: phaseCoverAssetPathOf(phase),
      numberLabel: translations.phaseSelection.phaseNumber(number: phaseNumberOf(phase)),
      status: switch (availability) {
        OpenPhaseAvailability() => PhaseCardStatus.open,
        WonPhaseAvailability() => PhaseCardStatus.won,
        LockedPhaseAvailability() => PhaseCardStatus.locked,
      },
      lockedReason: lockedReasonOf(translations, availability),
    );
  }
}

String? lockedReasonOf(Translations translations, PhaseAvailability availability) => switch (availability) {
  LockedPhaseAvailability(:final phaseToWin) => translations.phaseSelection.lockedReason(phase: phaseNameOf(translations, phaseToWin)),
  _ => null,
};
