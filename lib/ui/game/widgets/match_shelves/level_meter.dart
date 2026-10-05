import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_shadows.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';

const _badgeSize = 27.0;
const _barHeight = 8.0;
const _barMinimumWidth = 40.0;
const _barBorderWidth = 1.5;
const _barRadius = BorderRadius.all(Radius.circular(4));
const _fillDuration = Duration(milliseconds: 300);

const _levelStyle = TextStyle(
  fontSize: 14,
  color: AppColors.ink,
  fontFamily: AppFonts.display,
  fontWeight: FontWeight.w400,
);

const _experienceStyle = TextStyle(
  fontSize: 11,
  height: 13 / 11,
  color: AppColors.ink,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w900,
);

class LevelMeter extends StatelessWidget {
  const LevelMeter({
    required this.level,
    required this.label,
    required this.experience,
    required this.semanticLabel,
    required this.experienceToNextLevel,
    super.key,
  });

  final int level;
  final String label;
  final int experience;
  final String semanticLabel;
  final int? experienceToNextLevel;

  double get _filledFraction {
    final experienceToNextLevel = this.experienceToNextLevel;
    if (experienceToNextLevel == null || experienceToNextLevel <= 0) return 1;
    return (experience / experienceToNextLevel).clamp(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: Row(
          spacing: 6,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: AppShadows.pressOffset),
              child: Container(
                width: _badgeSize,
                height: _badgeSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.sun400,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.pressSun,
                  border: Border.all(color: AppColors.sun600, width: AppBorderWidth.thick),
                ),
                child: Text('$level', style: _levelStyle),
              ),
            ),
            Expanded(
              child: Column(
                spacing: 2,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: _experienceStyle),
                  _ExperienceBar(filledFraction: _filledFraction),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExperienceBar extends StatelessWidget {
  const _ExperienceBar({required this.filledFraction});

  final double filledFraction;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _barHeight,
      clipBehavior: Clip.antiAlias,
      constraints: const BoxConstraints(minWidth: _barMinimumWidth),
      decoration: BoxDecoration(
        borderRadius: _barRadius,
        color: AppColors.surface300,
        border: Border.all(color: AppColors.surface400, width: _barBorderWidth),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: AnimatedFractionallySizedBox(
          curve: Curves.easeOut,
          duration: _fillDuration,
          heightFactor: 1,
          widthFactor: filledFraction,
          child: const ColoredBox(color: AppColors.grass400),
        ),
      ),
    );
  }
}
