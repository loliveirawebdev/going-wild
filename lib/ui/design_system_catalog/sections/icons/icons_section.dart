import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/design/game_icon.dart';
import 'package:going_wild/ui/core/design/interface_glyph.dart';
import 'package:going_wild/ui/core/widgets/game_icon_image.dart';
import 'package:going_wild/ui/core/widgets/interface_glyph_image.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_block_title.dart';

class IconsSection extends StatelessWidget {
  const IconsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.space4),
      children: [
        const CatalogBlockTitle('Ícones de jogo'),
        Wrap(
          spacing: AppSpacing.space4,
          runSpacing: AppSpacing.space4,
          children: [
            for (final icon in GameIcon.values) _IconSample(name: icon.name, image: GameIconImage(icon, size: 48)),
          ],
        ),
        const CatalogBlockTitle('Glifos de interface'),
        Wrap(
          spacing: AppSpacing.space4,
          runSpacing: AppSpacing.space4,
          children: [
            for (final glyph in InterfaceGlyph.values) _IconSample(name: glyph.name, image: InterfaceGlyphImage(glyph, size: 32)),
          ],
        ),
      ],
    );
  }
}

class _IconSample extends StatelessWidget {
  const _IconSample({required this.name, required this.image});

  final String name;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Column(
        spacing: AppSpacing.space1,
        children: [
          SizedBox.square(dimension: 48, child: Center(child: image)),
          Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.label),
        ],
      ),
    );
  }
}
