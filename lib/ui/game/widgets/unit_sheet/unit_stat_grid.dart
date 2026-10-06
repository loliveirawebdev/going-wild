import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stats.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay_combatant.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/widgets/segmented_fill.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/design/game_icon.dart';
import 'package:going_wild/ui/core/localization/formatted_number.dart';
import 'package:going_wild/ui/core/widgets/game_icon_image.dart';

const _gridSpacing = 6.0;
const _iconSize = 20.0;
const _barHeight = 6.0;
const _barBorderWidth = 1.5;
const _barRadius = BorderRadius.all(Radius.circular(4));

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

const _maxValueStyle = TextStyle(fontSize: 12, color: AppColors.inkMuted);

class UnitStatGrid extends StatelessWidget {
  const UnitStatGrid({required this.stats, super.key, this.combatant});

  final Stats stats;
  final CombatReplayCombatant? combatant;

  @override
  Widget build(BuildContext context) {
    final translations = context.t.game.unitSheet;
    final statLabels = translations.stats;
    final attackSpeed = formattedNumberOf(context.t, (stats[Stat.attackSpeed] * 10).round() / 10);

    final combatant = this.combatant;
    final healthFraction = combatant == null ? 0.0 : _fractionOf(combatant.currentHealth, combatant.maxHealth);

    final tiles = [
      if (combatant == null) ...[
        _StatTile(icon: GameIcon.heart, label: statLabels.health, value: '${stats[Stat.health].round()}'),
        _StatTile(icon: GameIcon.mana, label: statLabels.mana, value: '${stats[Stat.manaMax].round()}'),
      ] else ...[
        _StatTile(
          icon: GameIcon.heart,
          label: statLabels.health,
          value: '${combatant.currentHealth.clamp(0, combatant.maxHealth).ceil()}',
          maxValue: '${combatant.maxHealth.round()}',
          barSegments: [
            (fraction: healthFraction, color: AppColors.healthHigh),
            (fraction: _fractionOf(combatant.currentShield, combatant.maxHealth).clamp(0, 1 - healthFraction), color: AppColors.shieldBar),
          ],
        ),
        _StatTile(
          icon: GameIcon.mana,
          label: statLabels.mana,
          value: '${combatant.currentMana.clamp(0, combatant.maxMana).floor()}',
          maxValue: '${combatant.maxMana.round()}',
          barSegments: [(fraction: _fractionOf(combatant.currentMana, combatant.maxMana), color: AppColors.mana)],
        ),
      ],
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

double _fractionOf(double value, double maxValue) => maxValue <= 0 ? 0 : (value / maxValue).clamp(0, 1);

class _StatTile extends StatelessWidget {
  const _StatTile({required this.icon, required this.label, required this.value, this.maxValue, this.barSegments});

  final String label;
  final String value;
  final GameIcon icon;
  final String? maxValue;
  final List<FillSegment>? barSegments;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surface200,
        borderRadius: AppRadius.small,
        border: Border.all(color: AppColors.surface400, width: AppBorderWidth.thin),
      ),
      child: Column(
        spacing: 2,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            spacing: 6,
            children: [
              GameIconImage(icon, size: _iconSize),
              Expanded(child: Text(label, style: _labelStyle)),
              Text.rich(
                TextSpan(
                  text: value,
                  children: [if (maxValue case final maxValue?) TextSpan(text: '/$maxValue', style: _maxValueStyle)],
                ),
                style: _valueStyle,
              ),
            ],
          ),
          if (barSegments case final barSegments?) _StatBar(segments: barSegments),
        ],
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  const _StatBar({required this.segments});

  final List<FillSegment> segments;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _barHeight,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface300,
        borderRadius: _barRadius,
        border: Border.all(color: AppColors.outline, width: _barBorderWidth),
      ),
      child: SegmentedFill(segments: segments),
    );
  }
}
