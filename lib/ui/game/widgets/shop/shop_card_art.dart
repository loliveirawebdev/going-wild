import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/set/team_set.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/design/character_portrait.dart';
import 'package:going_wild/ui/core/design/game_icon.dart';
import 'package:going_wild/ui/core/design/rarity_color.dart';
import 'package:going_wild/ui/core/localization/set_name.dart';
import 'package:going_wild/ui/core/widgets/game_icon_image.dart';
import 'package:going_wild/ui/core/widgets/set_icon_image.dart';

const _edgeInset = 5.0;
const _rangeIconSize = 16.0;
const _setIconSize = 14.0;

const _rangeStyle = TextStyle(
  fontSize: 13,
  height: 1,
  color: AppColors.ink,
  fontFamily: AppFonts.display,
  fontWeight: FontWeight.w400,
);

const _setStyle = TextStyle(
  fontSize: 11,
  height: 15 / 11,
  color: AppColors.ink,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w800,
);

class ShopCardArt extends StatelessWidget {
  final int range;
  final bool isFaded;
  final List<TeamSet> sets;
  final Character character;
  const ShopCardArt({required this.sets, required this.range, required this.character, required this.isFaded, super.key});

  @override
  Widget build(BuildContext context) {
    final rarityColor = rarityColorOf(character.rarity);

    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: AppColors.surface200),
          Opacity(
            opacity: isFaded ? 0.6 : 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(characterPortraitAssetPathOf(character), fit: BoxFit.cover, alignment: Alignment.centerRight),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      stops: const [0, 0.3, 0.58],
                      colors: [rarityColor.withValues(alpha: 0.55), rarityColor.withValues(alpha: 0.25), rarityColor.withValues(alpha: 0)],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: _edgeInset,
            right: _edgeInset,
            child: _RangeTag(range: range),
          ),
          Positioned(
            left: _edgeInset,
            right: _edgeInset,
            bottom: _edgeInset,
            child: Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [for (final set in sets) _SetTag(set: set)],
            ),
          ),
        ],
      ),
    );
  }
}

class _RangeTag extends StatelessWidget {
  final int range;
  const _RangeTag({required this.range});

  @override
  Widget build(BuildContext context) {
    final isMelee = range <= 1;

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(color: AppColors.surface100.withValues(alpha: 0.75), borderRadius: AppRadius.pill),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GameIconImage(isMelee ? GameIcon.melee : GameIcon.ranged, size: _rangeIconSize),
          if (!isMelee)
            Padding(
              padding: const EdgeInsets.only(left: 1, right: 3),
              child: Text('$range', style: _rangeStyle),
            ),
        ],
      ),
    );
  }
}

class _SetTag extends StatelessWidget {
  final TeamSet set;
  const _SetTag({required this.set});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(2, 0, 6, 0),
      decoration: BoxDecoration(color: AppColors.surface100.withValues(alpha: 0.78), borderRadius: AppRadius.pill),
      child: Row(
        spacing: 3,
        mainAxisSize: MainAxisSize.min,
        children: [
          SetIconImage(set.id, size: _setIconSize),
          Flexible(
            child: Text(setNameOf(context.t, set), maxLines: 1, overflow: TextOverflow.ellipsis, style: _setStyle),
          ),
        ],
      ),
    );
  }
}
