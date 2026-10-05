import 'package:going_wild/ui/design_system_catalog/design_system_catalog_section.dart';
import 'package:going_wild/ui/design_system_catalog/sections/button/button_section.dart';
import 'package:going_wild/ui/design_system_catalog/sections/icons/icons_section.dart';
import 'package:going_wild/ui/design_system_catalog/sections/progress_bar/progress_bar_section.dart';
import 'package:going_wild/ui/design_system_catalog/sections/round_icon_button/round_icon_button_section.dart';
import 'package:going_wild/ui/design_system_catalog/sections/tokens/tokens_section.dart';

final designSystemCatalogSections = [
  DesignSystemCatalogSection(title: 'Tokens', builder: (context) => const TokensSection()),
  DesignSystemCatalogSection(title: 'Ícones', builder: (context) => const IconsSection()),
  DesignSystemCatalogSection(title: 'Button', builder: (context) => const ButtonSection()),
  DesignSystemCatalogSection(title: 'RoundIconButton', builder: (context) => const RoundIconButtonSection()),
  DesignSystemCatalogSection(title: 'ProgressBar', builder: (context) => const ProgressBarSection()),
];
