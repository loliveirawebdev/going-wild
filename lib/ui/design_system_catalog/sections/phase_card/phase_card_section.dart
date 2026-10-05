import 'package:flutter/widgets.dart';
import 'package:going_wild/content/phase/phases.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_block_title.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_tap_log.dart';
import 'package:going_wild/ui/phase_selection/phase_cover.dart';
import 'package:going_wild/ui/phase_selection/widgets/phase_card.dart';

class PhaseCardSection extends StatelessWidget {
  const PhaseCardSection({super.key});

  @override
  Widget build(BuildContext context) {
    final coverAssetPath = phaseCoverAssetPathOf(backyard);

    return CatalogTapLog(
      builder: (context, tapOf) => ListView(
        padding: const EdgeInsets.all(AppSpacing.space4),
        children: [
          const CatalogBlockTitle('Aberta'),
          Center(
            child: PhaseCard(
              name: 'Quintal',
              numberLabel: 'Fase 1',
              onPressed: tapOf('Quintal'),
              coverAssetPath: coverAssetPath,
              details: const [PhaseCardDetail(label: 'Rodadas', value: '10')],
            ),
          ),
          const CatalogBlockTitle('Nome comprido'),
          Center(
            child: PhaseCard(
              numberLabel: 'Fase 12',
              coverAssetPath: coverAssetPath,
              onPressed: tapOf('Nome comprido'),
              name: 'Pântano das Cobras Venenosas',
              details: const [PhaseCardDetail(label: 'Rodadas', value: '10')],
            ),
          ),
          const SizedBox(height: AppSpacing.space6),
        ],
      ),
    );
  }
}
