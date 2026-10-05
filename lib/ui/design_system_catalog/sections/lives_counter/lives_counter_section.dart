import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_block_title.dart';
import 'package:going_wild/ui/game/widgets/match_top_bar/lives_counter.dart';

class LivesCounterSection extends StatelessWidget {
  const LivesCounterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.space4),
      children: [
        const CatalogBlockTitle('Vidas restantes'),
        Column(
          spacing: AppSpacing.space3,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var lives = 3; lives >= 0; lives--) LivesCounter(lives: lives, maxLives: 3, semanticLabel: '$lives de 3 vidas'),
          ],
        ),
        const CatalogBlockTitle('Na partida'),
        const LivesCounter(lives: 2, maxLives: 3, heartSize: 18, semanticLabel: '2 de 3 vidas'),
      ],
    );
  }
}
