import 'package:flutter/widgets.dart';
import 'package:going_wild/content/phase/phases.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_block_title.dart';
import 'package:going_wild/ui/phase_selection/phase_cover.dart';
import 'package:going_wild/ui/phase_selection/widgets/phase_card.dart';

class PhaseCardSection extends StatelessWidget {
  const PhaseCardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.space4),
      children: [
        const CatalogBlockTitle('Aberta'),
        Center(
          child: PhaseCard(name: 'Quintal', numberLabel: 'Fase 1', coverAssetPath: phaseCoverAssetPathOf(backyard)),
        ),
        const CatalogBlockTitle('Nome comprido'),
        Center(
          child: PhaseCard(
            numberLabel: 'Fase 12',
            name: 'Pântano das Cobras Venenosas',
            coverAssetPath: phaseCoverAssetPathOf(backyard),
          ),
        ),
        const SizedBox(height: AppSpacing.space6),
      ],
    );
  }
}
