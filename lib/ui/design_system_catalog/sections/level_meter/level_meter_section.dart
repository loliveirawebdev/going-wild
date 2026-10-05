import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_block_title.dart';
import 'package:going_wild/ui/game/widgets/match_shelves/level_meter.dart';

const _meterWidth = 220.0;

class LevelMeterSection extends StatelessWidget {
  const LevelMeterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.space4),
      children: const [
        CatalogBlockTitle('Progresso de XP'),
        SizedBox(
          width: _meterWidth,
          child: Column(
            spacing: AppSpacing.space3,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: _meterWidth,
                child: LevelMeter(level: 1, experience: 0, experienceToNextLevel: 2, label: 'XP 0/2', semanticLabel: 'Nível 1, XP 0 de 2'),
              ),
              SizedBox(
                width: _meterWidth,
                child: LevelMeter(level: 3, experience: 3, experienceToNextLevel: 8, label: 'XP 3/8', semanticLabel: 'Nível 3, XP 3 de 8'),
              ),
              SizedBox(
                width: _meterWidth,
                child: LevelMeter(
                  level: 9,
                  experience: 0,
                  experienceToNextLevel: null,
                  label: 'Nível máx.',
                  semanticLabel: 'Nível 9, máximo',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
