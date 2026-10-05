import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/phase/phase.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/phase_name.dart';
import 'package:going_wild/ui/phase_selection/phase_cover.dart';
import 'package:going_wild/ui/phase_selection/widgets/phase_card.dart';

const _neighborScaleReduction = 0.14;
const _neighborOpacityReduction = 0.3;

class PhaseCarousel extends StatelessWidget {
  const PhaseCarousel({
    required this.phases,
    required this.controller,
    required this.selectedIndex,
    required this.onPhaseChanged,
    super.key,
  });

  final List<Phase> phases;
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
          child: PhaseCard(
            name: phaseNameOf(translations, phases[index]),
            coverAssetPath: phaseCoverAssetPathOf(phases[index]),
            numberLabel: translations.phaseSelection.phaseNumber(number: index + 1),
          ),
        ),
      ),
    );
  }
}
