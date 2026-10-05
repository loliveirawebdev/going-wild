import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stats.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/design/game_icon.dart';
import 'package:going_wild/ui/core/localization/formatted_number.dart';
import 'package:going_wild/ui/core/widgets/game_icon_image.dart';

const _gridSpacing = 6.0;
const _iconSize = 20.0;

const _labelStyle = TextStyle(
  fontSize: 11,
  height: 14 / 11,
  color: AppColors.inkMuted,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w800,
);

const _valueStyle = TextStyle(
  fontSize: 17,
  height: 20 / 17,
  color: AppColors.ink,
  fontFamily: AppFonts.display,
  fontWeight: FontWeight.w400,
);

class UnitStatGrid extends StatelessWidget {
  const UnitStatGrid({required this.stats, super.key});

  final Stats stats;

  @override
  Widget build(BuildContext context) {
    final translations = context.t.game.unitSheet;
    final statLabels = translations.stats;
    final attackSpeed = formattedNumberOf(context.t, (stats[Stat.attackSpeed] * 10).round() / 10);

    final tiles = [
      _StatTile(icon: GameIcon.heart, label: statLabels.health, value: '${stats[Stat.health].round()}'),
      _StatTile(icon: GameIcon.mana, label: statLabels.mana, value: '${stats[Stat.manaMax].round()}'),
      _StatTile(icon: GameIcon.sword, label: statLabels.damage, value: '${stats[Stat.damage].round()}'),
      _StatTile(icon: GameIcon.shield, label: statLabels.armor, value: '${stats[Stat.armor].round()}'),
      _StatTile(
        icon: GameIcon.attackSpeed,
        label: statLabels.attackSpeed,
        value: translations.attackSpeedValue(value: attackSpeed),
      ),
    ];

    return Column(
      spacing: _gridSpacing,
      children: [
        for (var rowStart = 0; rowStart < tiles.length; rowStart += 2)
          Row(
            spacing: _gridSpacing,
            children: [
              Expanded(child: tiles[rowStart]),
              Expanded(child: rowStart + 1 < tiles.length ? tiles[rowStart + 1] : const SizedBox.shrink()),
            ],
          ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.icon, required this.label, required this.value});

  final String label;
  final String value;
  final GameIcon icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surface200,
        borderRadius: AppRadius.small,
        border: Border.all(color: AppColors.surface400, width: AppBorderWidth.thin),
      ),
      child: Row(
        spacing: 6,
        children: [
          GameIconImage(icon, size: _iconSize),
          Expanded(child: Text(label, style: _labelStyle)),
          Text(value, style: _valueStyle),
        ],
      ),
    );
  }
}
