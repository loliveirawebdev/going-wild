import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/game_icon.dart';
import 'package:going_wild/ui/core/widgets/stat_counter.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_block_title.dart';

class StatCounterSection extends StatelessWidget {
  const StatCounterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.space4),
      children: const [
        CatalogBlockTitle('Moedas'),
        Wrap(
          spacing: AppSpacing.space3,
          runSpacing: AppSpacing.space3,
          children: [
            StatCounter(icon: GameIcon.gold, value: 0, semanticLabel: '0 moedas'),
            StatCounter(icon: GameIcon.gold, value: 7, semanticLabel: '7 moedas'),
            StatCounter(icon: GameIcon.gold, value: 128, semanticLabel: '128 moedas'),
          ],
        ),
      ],
    );
  }
}
