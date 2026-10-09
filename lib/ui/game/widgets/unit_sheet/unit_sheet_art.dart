import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/set/team_set.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_color_filters.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/design/character_art.dart';
import 'package:going_wild/ui/core/design/interface_glyph.dart';
import 'package:going_wild/ui/core/design/rarity_color.dart';
import 'package:going_wild/ui/core/widgets/pill.dart';
import 'package:going_wild/ui/core/widgets/rarity_art_gradient.dart';
import 'package:going_wild/ui/core/widgets/round_icon_button.dart';
import 'package:going_wild/ui/game/widgets/set_tag/set_tag.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_side.dart';

const _artAspectRatio = 4 / 3;
const _edgeInset = 8.0;

const _sideTagStyle = TextStyle(
  fontSize: 11,
  height: 16 / 11,
  letterSpacing: 0.5,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w900,
);

class UnitSheetArt extends StatelessWidget {
  const UnitSheetArt({required this.side, required this.sets, required this.character, super.key, this.isFallen = false});

  final bool isFallen;
  final UnitSide side;
  final Character character;
  final List<TeamSet> sets;

  @override
  Widget build(BuildContext context) {
    final rarityColor = rarityColorOf(character.rarity);

    return AspectRatio(
      aspectRatio: _artAspectRatio,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: AppColors.surface300),
          ColorFiltered(
            colorFilter: isFallen ? AppColorFilters.fallenArt : AppColorFilters.none,
            child: Image.asset(characterAvatarAssetPathOf(character), fit: BoxFit.cover, alignment: Alignment.centerRight),
          ),
          RarityArtGradient(rarityColor: rarityColor),
          Positioned(
            top: _edgeInset,
            left: _edgeInset,
            child: _SideTag(side: side),
          ),
          Positioned(
            top: _edgeInset,
            right: _edgeInset,
            child: RoundIconButton(
              glyph: InterfaceGlyph.close,
              size: RoundIconButtonSize.extraSmall,
              label: context.t.game.unitSheet.closeButton,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            left: _edgeInset,
            bottom: _edgeInset,
            child: Column(
              spacing: 3,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [for (final set in sets) SetTag(set: set, size: SetTagSize.regular)],
            ),
          ),
        ],
      ),
    );
  }
}

class _SideTag extends StatelessWidget {
  const _SideTag({required this.side});

  final UnitSide side;

  @override
  Widget build(BuildContext context) {
    final translations = context.t.game.unitSheet;
    final (label, fillColor, edgeColor, textColor) = switch (side) {
      UnitSide.team => (translations.teamTag, AppColors.grass400, AppColors.grass600, AppColors.ink),
      UnitSide.enemy => (translations.enemyTag, AppColors.barn600, AppColors.barn800, AppColors.onPrimary),
    };

    return Pill(
      color: fillColor,
      borderColor: edgeColor,
      borderWidth: AppBorderWidth.thick,
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      child: Text(label.toUpperCase(), style: _sideTagStyle.copyWith(color: textColor)),
    );
  }
}
