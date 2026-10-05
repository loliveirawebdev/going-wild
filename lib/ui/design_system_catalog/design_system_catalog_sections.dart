import 'package:going_wild/ui/design_system_catalog/design_system_catalog_section.dart';
import 'package:going_wild/ui/design_system_catalog/sections/button/button_section.dart';
import 'package:going_wild/ui/design_system_catalog/sections/icons/icons_section.dart';
import 'package:going_wild/ui/design_system_catalog/sections/tokens/tokens_section.dart';

final designSystemCatalogSections = [
  DesignSystemCatalogSection(title: 'Tokens', builder: (context) => const TokensSection()),
  DesignSystemCatalogSection(title: 'Ícones', builder: (context) => const IconsSection()),
  DesignSystemCatalogSection(title: 'Button', builder: (context) => const ButtonSection()),
];
