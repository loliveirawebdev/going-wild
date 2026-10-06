import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stats.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay_combatant.dart';
import 'package:going_wild/domain/models/phase/phase_engines.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_shadows.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/design/rarity_color.dart';
import 'package:going_wild/ui/core/widgets/dialog.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/range_badge.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/role_badge.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_ability_block.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_combat_effects.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_sale.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_sell_button.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_sheet_art.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_sheet_name_bar.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_side.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_stat_grid.dart';

const _maxSheetWidth = 340.0;
const _rarityFrameWidth = 3.0;
const _innerRadius = BorderRadius.all(Radius.circular(22 - _rarityFrameWidth));

Future<void> presentUnitSheet(
  BuildContext context, {
  required UnitSide side,
  required PhaseEngines engines,
  required CharacterCopy characterCopy,
  UnitSale? sale,
  Stats? stats,
}) {
  return presentDialog<void>(
    context,
    barrierLabel: context.t.game.unitSheet.closeButton,
    dialog: UnitSheet(side: side, sale: sale, stats: stats, engines: engines, characterCopy: characterCopy),
  );
}

class UnitSheet extends StatelessWidget {
  const UnitSheet({
    required this.side,
    required this.engines,
    required this.characterCopy,
    super.key,
    this.sale,
    this.stats,
    this.combatant,
  });

  final UnitSide side;
  final UnitSale? sale;
  final PhaseEngines engines;
  final CharacterCopy characterCopy;
  final Stats? stats;
  final CombatReplayCombatant? combatant;

  @override
  Widget build(BuildContext context) {
    final sale = this.sale;
    final combatant = this.combatant;
    final character = characterCopy.character;
    final stats = combatant?.currentStats ?? this.stats ?? engines.characterEngine.statsAtStars(character, stars: characterCopy.stars);

    return DefaultTextStyle(
      style: AppTextStyles.body,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.space4),
            child: Container(
              constraints: const BoxConstraints(maxWidth: _maxSheetWidth),
              decoration: BoxDecoration(
                color: AppColors.surface100,
                borderRadius: AppRadius.large,
                boxShadow: AppShadows.float,
                border: Border.all(color: rarityColorOf(character.rarity), width: _rarityFrameWidth),
              ),
              child: ClipRRect(
                borderRadius: _innerRadius,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      UnitSheetArt(
                        side: side,
                        character: character,
                        sets: engines.setEngine.setsOf(character),
                        isFallen: combatant != null && !combatant.isAlive,
                      ),
                      UnitSheetNameBar(characterCopy: characterCopy),
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.space3),
                        child: Column(
                          spacing: AppSpacing.space3,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: [
                                RoleBadge(role: character.role),
                                RangeBadge(stats: stats),
                              ],
                            ),
                            UnitStatGrid(stats: stats, combatant: combatant),
                            UnitAbilityBlock(stars: characterCopy.stars, ability: character.ability, manaCost: stats[Stat.manaMax]),
                            if (combatant != null) UnitCombatEffects(combatant: combatant, edgeBleed: AppSpacing.space3),
                            if (side == UnitSide.team && sale != null) UnitSellButton(sale: sale),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
