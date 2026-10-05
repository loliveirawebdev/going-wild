import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/design_system_catalog/sections/tokens/color_tokens.dart';
import 'package:going_wild/ui/design_system_catalog/sections/tokens/shape_tokens.dart';
import 'package:going_wild/ui/design_system_catalog/sections/tokens/spacing_tokens.dart';
import 'package:going_wild/ui/design_system_catalog/sections/tokens/text_style_tokens.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_block_title.dart';

class TokensSection extends StatelessWidget {
  const TokensSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.space4),
      children: const [
        CatalogBlockTitle('Cores'),
        ColorTokens(),
        CatalogBlockTitle('Texto'),
        TextStyleTokens(),
        CatalogBlockTitle('Formas'),
        ShapeTokens(),
        CatalogBlockTitle('Espaços'),
        SpacingTokens(),
      ],
    );
  }
}
