import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/set/team_set.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/design/character_art.dart';
import 'package:going_wild/ui/core/design/interface_glyph.dart';
import 'package:going_wild/ui/core/design/rarity_color.dart';
import 'package:going_wild/ui/core/localization/set_name.dart';
import 'package:going_wild/ui/core/widgets/round_icon_button.dart';
import 'package:going_wild/ui/core/widgets/set_icon_image.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_side.dart';

const _artAspectRatio = 4 / 3;
const _edgeInset = 8.0;
const _setIconSize = 15.0;

const _sideTagStyle = TextStyle(
  fontSize: 11,
  height: 16 / 11,
  letterSpacing: 0.5,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w900,
);

const _setTagStyle = TextStyle(
  fontSize: 11,
  height: 16 / 11,
  color: AppColors.ink,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w800,
);

class UnitSheetArt extends StatelessWidget {
  const UnitSheetArt({required this.side, required this.sets, required this.character, super.key});

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
          Image.asset(characterAvatarAssetPathOf(character), fit: BoxFit.cover, alignment: Alignment.centerRight),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                stops: const [0, 0.3, 0.58],
                colors: [rarityColor.withValues(alpha: 0.55), rarityColor.withValues(alpha: 0.25), rarityColor.withValues(alpha: 0)],
              ),
            ),
          ),
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
              children: [for (final set in sets) _SetTag(set: set)],
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

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: AppRadius.pill,
        border: Border.all(color: edgeColor, width: AppBorderWidth.thick),
      ),
      child: Text(label.toUpperCase(), style: _sideTagStyle.copyWith(color: textColor)),
    );
  }
}

class _SetTag extends StatelessWidget {
  const _SetTag({required this.set});

  final TeamSet set;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(3, 1, 8, 1),
      decoration: BoxDecoration(color: AppColors.surface100.withValues(alpha: 0.85), borderRadius: AppRadius.pill),
      child: Row(
        spacing: 4,
        mainAxisSize: MainAxisSize.min,
        children: [
          SetIconImage(set.id, size: _setIconSize),
          Text(setNameOf(context.t, set), style: _setTagStyle),
        ],
      ),
    );
  }
}
