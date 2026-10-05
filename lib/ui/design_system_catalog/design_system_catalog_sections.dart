import 'package:going_wild/ui/design_system_catalog/design_system_catalog_section.dart';
import 'package:going_wild/ui/design_system_catalog/sections/tokens/tokens_section.dart';

final designSystemCatalogSections = [
  DesignSystemCatalogSection(
    title: 'Tokens',
    builder: (context) => const TokensSection(),
  ),
];
