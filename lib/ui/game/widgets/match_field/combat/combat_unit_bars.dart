import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay_combatant.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';

const _healthBarHeight = 5.0;
const _manaBarHeight = 3.0;
const _barBorderWidth = 1.0;
const _mediumHealthFraction = 0.6;
const _lowHealthFraction = 0.3;

class CombatUnitBars extends StatelessWidget {
  final double width;
  final CombatReplayCombatant combatant;
  const CombatUnitBars({required this.width, required this.combatant, super.key});

  Color get _healthColor {
    final healthFraction = combatant.currentHealth / combatant.maxHealth;
    if (healthFraction <= _lowHealthFraction) return AppColors.healthLow;
    if (healthFraction <= _mediumHealthFraction) return AppColors.healthMedium;
    return AppColors.healthHigh;
  }

  @override
  Widget build(BuildContext context) {
    final healthFraction = (combatant.currentHealth / combatant.maxHealth).clamp(0.0, 1.0);
    final shieldFraction = (combatant.currentShield / combatant.maxHealth).clamp(0.0, 1.0 - healthFraction);
    final manaFraction = combatant.maxMana <= 0 ? 0.0 : (combatant.currentMana / combatant.maxMana).clamp(0.0, 1.0);

    return SizedBox(
      width: width,
      child: Column(
        spacing: 1,
        mainAxisSize: MainAxisSize.min,
        children: [
          _Bar(
            height: _healthBarHeight,
            segments: [(fraction: healthFraction, color: _healthColor), (fraction: shieldFraction, color: AppColors.shieldBar)],
          ),
          _Bar(height: _manaBarHeight, segments: [(fraction: manaFraction, color: AppColors.mana)]),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double height;
  final List<({double fraction, Color color})> segments;
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
      child: Row(
        children: [
          for (final segment in segments)
            if (segment.fraction > 0)
              Flexible(
                flex: (segment.fraction * 1000).round(),
                child: ColoredBox(color: segment.color, child: const SizedBox.expand()),
              ),
          if (segments.fold(0.0, (sum, segment) => sum + segment.fraction) < 1)
            Flexible(
              flex: ((1 - segments.fold(0.0, (sum, segment) => sum + segment.fraction)) * 1000).round(),
              child: const SizedBox.expand(),
            ),
        ],
      ),
    );
  }
}
