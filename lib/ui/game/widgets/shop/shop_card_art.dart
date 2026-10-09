import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stats.dart';
import 'package:going_wild/domain/models/set/team_set.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/design/character_art.dart';
import 'package:going_wild/ui/core/design/game_icon.dart';
import 'package:going_wild/ui/core/design/rarity_color.dart';
import 'package:going_wild/ui/core/widgets/game_icon_image.dart';
import 'package:going_wild/ui/core/widgets/pill.dart';
import 'package:going_wild/ui/core/widgets/rarity_art_gradient.dart';
import 'package:going_wild/ui/game/widgets/set_tag/set_tag.dart';

const _edgeInset = 5.0;
const _rangeIconSize = 16.0;

const _rangeStyle = TextStyle(
  fontSize: 13,
  height: 1,
  color: AppColors.ink,
  fontFamily: AppFonts.display,
  fontWeight: FontWeight.w400,
);

class ShopCardArt extends StatelessWidget {
  final Stats stats;
  final bool isFaded;
  final List<TeamSet> sets;
  final Character character;
  const ShopCardArt({required this.sets, required this.stats, required this.character, required this.isFaded, super.key});

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
                Image.asset(characterAvatarAssetPathOf(character), fit: BoxFit.cover, alignment: Alignment.centerRight),
                RarityArtGradient(rarityColor: rarityColor),
              ],
            ),
          ),
          Positioned(
            top: _edgeInset,
            right: _edgeInset,
            child: _RangeTag(stats: stats),
          ),
          Positioned(
            left: _edgeInset,
            right: _edgeInset,
            bottom: _edgeInset,
            child: Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [for (final set in sets) SetTag(set: set, size: SetTagSize.compact)],
            ),
          ),
        ],
      ),
    );
  }
}

class _RangeTag extends StatelessWidget {
  final Stats stats;
  const _RangeTag({required this.stats});

  @override
  Widget build(BuildContext context) {
    final isMelee = stats.isMelee;

    return Pill(
      padding: const EdgeInsets.all(2),
      color: AppColors.surface100.withValues(alpha: 0.75),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GameIconImage(isMelee ? GameIcon.melee : GameIcon.ranged, size: _rangeIconSize),
          if (!isMelee)
            Padding(
              padding: const EdgeInsets.only(left: 1, right: 3),
              child: Text('${stats[Stat.range].round()}', style: _rangeStyle),
            ),
        ],
      ),
    );
  }
}
