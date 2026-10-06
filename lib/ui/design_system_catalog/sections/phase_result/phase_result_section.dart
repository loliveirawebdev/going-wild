import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_block_title.dart';
import 'package:going_wild/ui/game/widgets/phase_result/phase_result_panel.dart';

class PhaseResultSection extends StatelessWidget {
  const PhaseResultSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.space4),
      children: [
        const CatalogBlockTitle('Fase vencida'),
        _Stage(
          child: PhaseResultPanel(
            lives: 2,
            maxLives: 3,
            roundCount: 10,
            phaseNumber: 1,
            isVictory: true,
            roundsReached: 10,
            phaseName: 'Quintal',
            onBack: () {},
            onRetry: () {},
          ),
        ),
        const CatalogBlockTitle('Fase perdida'),
        _Stage(
          child: PhaseResultPanel(
            lives: 0,
            maxLives: 3,
            roundCount: 10,
            phaseNumber: 1,
            isVictory: false,
            roundsReached: 6,
            phaseName: 'Quintal',
            onBack: () {},
            onRetry: () {},
          ),
        ),
      ],
    );
  }
}

class _Stage extends StatelessWidget {
  const _Stage({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.sceneGrass,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.space4, AppSpacing.space8, AppSpacing.space4, AppSpacing.space4),
        child: Center(child: child),
      ),
    );
  }
}
