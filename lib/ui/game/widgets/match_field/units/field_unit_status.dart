import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay_combatant.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/widgets/segmented_fill.dart';
import 'package:going_wild/ui/core/widgets/stars.dart';

const _healthBarHeight = 5.0;
const _manaBarHeight = 3.0;
const _barBorderWidth = 1.0;
const _barsGap = 1.0;
const _starSizeToWidth = 0.3;
const _mediumHealthFraction = 0.6;
const _lowHealthFraction = 0.3;

typedef FieldUnitVitals = ({double healthFraction, double shieldFraction, double manaFraction});

FieldUnitVitals combatVitalsOf(CombatReplayCombatant combatant) {
  final healthFraction = _fractionOf(combatant.currentHealth, combatant.maxHealth);

  return (
    healthFraction: healthFraction,
    manaFraction: _fractionOf(combatant.currentMana, combatant.maxMana),
    shieldFraction: _fractionOf(combatant.currentShield, combatant.maxHealth).clamp(0, 1 - healthFraction),
  );
}

double _fractionOf(double value, double maxValue) => maxValue <= 0 ? 0 : (value / maxValue).clamp(0, 1);

class FieldUnitStatus extends StatelessWidget {
  final int stars;
  final double width;
  final FieldUnitVitals vitals;
  const FieldUnitStatus({required this.stars, required this.width, required this.vitals, super.key});

  Color get _healthColor {
    if (vitals.healthFraction <= _lowHealthFraction) return AppColors.healthLow;
    if (vitals.healthFraction <= _mediumHealthFraction) return AppColors.healthMedium;
    return AppColors.healthHigh;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        spacing: _barsGap,
        mainAxisSize: MainAxisSize.min,
        children: [
          _Bar(
            height: _healthBarHeight,
            segments: [
              (fraction: vitals.healthFraction, color: _healthColor),
              (fraction: vitals.shieldFraction, color: AppColors.shieldBar),
            ],
          ),
          _Bar(height: _manaBarHeight, segments: [(fraction: vitals.manaFraction, color: AppColors.mana)]),
          Stars(
            count: stars,
            outlineColor: AppColors.ink,
            size: width * _starSizeToWidth,
            semanticLabel: context.t.game.bench.stars(count: stars),
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double height;
  final List<FillSegment> segments;
  const _Bar({required this.height, required this.segments});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height + _barBorderWidth * 2,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.wood700,
        borderRadius: AppRadius.pill,
        border: Border.all(color: AppColors.wood700, width: _barBorderWidth),
      ),

      child: SegmentedFill(segments: segments),
    );
  }
}
