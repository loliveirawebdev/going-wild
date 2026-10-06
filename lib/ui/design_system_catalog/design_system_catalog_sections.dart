import 'package:going_wild/ui/design_system_catalog/design_system_catalog_section.dart';
import 'package:going_wild/ui/design_system_catalog/sections/bench_slot/bench_slot_section.dart';
import 'package:going_wild/ui/design_system_catalog/sections/button/button_section.dart';
import 'package:going_wild/ui/design_system_catalog/sections/dialog/dialog_section.dart';
import 'package:going_wild/ui/design_system_catalog/sections/icons/icons_section.dart';
import 'package:going_wild/ui/design_system_catalog/sections/level_meter/level_meter_section.dart';
import 'package:going_wild/ui/design_system_catalog/sections/lives_counter/lives_counter_section.dart';
import 'package:going_wild/ui/design_system_catalog/sections/phase_card/phase_card_section.dart';
import 'package:going_wild/ui/design_system_catalog/sections/phase_result/phase_result_section.dart';
import 'package:going_wild/ui/design_system_catalog/sections/progress_bar/progress_bar_section.dart';
import 'package:going_wild/ui/design_system_catalog/sections/round_banner/round_banner_section.dart';
import 'package:going_wild/ui/design_system_catalog/sections/round_icon_button/round_icon_button_section.dart';
import 'package:going_wild/ui/design_system_catalog/sections/set_chip/set_chip_section.dart';
import 'package:going_wild/ui/design_system_catalog/sections/set_dialog/set_dialog_section.dart';
import 'package:going_wild/ui/design_system_catalog/sections/settings_controls/slider_section.dart';
import 'package:going_wild/ui/design_system_catalog/sections/shop_card/shop_card_section.dart';
import 'package:going_wild/ui/design_system_catalog/sections/settings_controls/speed_selector_section.dart';
import 'package:going_wild/ui/design_system_catalog/sections/settings_controls/switch_section.dart';
import 'package:going_wild/ui/design_system_catalog/sections/stars/stars_section.dart';
import 'package:going_wild/ui/design_system_catalog/sections/stat_counter/stat_counter_section.dart';
import 'package:going_wild/ui/design_system_catalog/sections/summon_poof/summon_poof_section.dart';
import 'package:going_wild/ui/design_system_catalog/sections/tokens/tokens_section.dart';
import 'package:going_wild/ui/design_system_catalog/sections/unit_sheet/unit_sheet_section.dart';

final designSystemCatalogSections = [
  DesignSystemCatalogSection(title: 'Tokens', builder: (context) => const TokensSection()),
  DesignSystemCatalogSection(title: 'Ícones', builder: (context) => const IconsSection()),
  DesignSystemCatalogSection(title: 'Button', builder: (context) => const ButtonSection()),
  DesignSystemCatalogSection(title: 'RoundIconButton', builder: (context) => const RoundIconButtonSection()),
  DesignSystemCatalogSection(title: 'ProgressBar', builder: (context) => const ProgressBarSection()),
  DesignSystemCatalogSection(title: 'PhaseCard', builder: (context) => const PhaseCardSection()),
  DesignSystemCatalogSection(title: 'Slider', builder: (context) => const SliderSection()),
  DesignSystemCatalogSection(title: 'Switch', builder: (context) => const SwitchSection()),
  DesignSystemCatalogSection(title: 'SpeedSelector', builder: (context) => const SpeedSelectorSection()),
  DesignSystemCatalogSection(title: 'Dialog', builder: (context) => const DialogSection()),
  DesignSystemCatalogSection(title: 'LivesCounter', builder: (context) => const LivesCounterSection()),
  DesignSystemCatalogSection(title: 'SetChip', builder: (context) => const SetChipSection()),
  DesignSystemCatalogSection(title: 'SetDialog', builder: (context) => const SetDialogSection()),
  DesignSystemCatalogSection(title: 'LevelMeter', builder: (context) => const LevelMeterSection()),
  DesignSystemCatalogSection(title: 'StatCounter', builder: (context) => const StatCounterSection()),
  DesignSystemCatalogSection(title: 'Stars', builder: (context) => const StarsSection()),
  DesignSystemCatalogSection(title: 'BenchSlot', builder: (context) => const BenchSlotSection()),
  DesignSystemCatalogSection(title: 'UnitSheet', builder: (context) => const UnitSheetSection()),
  DesignSystemCatalogSection(title: 'ShopCard', builder: (context) => const ShopCardSection()),
  DesignSystemCatalogSection(title: 'SummonPoof', builder: (context) => const SummonPoofSection()),
  DesignSystemCatalogSection(title: 'RoundBanner', builder: (context) => const RoundBannerSection()),
  DesignSystemCatalogSection(title: 'PhaseResult', builder: (context) => const PhaseResultSection()),
];
