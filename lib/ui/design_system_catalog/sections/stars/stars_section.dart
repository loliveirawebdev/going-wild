import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/widgets/stars.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_block_title.dart';

const _starSizes = [10.0, 13.0, 18.0, 26.0];

class StarsSection extends StatelessWidget {
  const StarsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.space4),
      children: [
        for (final size in _starSizes) ...[
          CatalogBlockTitle('${size.round()}px'),
          Wrap(
            spacing: AppSpacing.space6,
            runSpacing: AppSpacing.space3,
            children: [
              for (var count = 1; count <= 3; count++)
                Stars(
                  size: size,
                  count: count,
                  semanticLabel: '$count estrelas',
                ),
            ],
          ),
        ],
      ],
    );
  }
}
