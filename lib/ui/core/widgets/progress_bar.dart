import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';

const _trackHeight = 22.0;
const _fillDuration = Duration(milliseconds: 250);

const _labelStyle = TextStyle(
  fontSize: 14,
  height: 18 / 14,
  color: AppColors.ink,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w800,
);

const _valueStyle = TextStyle(
  fontSize: 16,
  letterSpacing: 0.5,
  color: AppColors.ink,
  fontFamily: AppFonts.display,
  fontWeight: FontWeight.w400,
);

enum ProgressBarTone {
  sky(fill: AppColors.sky300),
  sun(fill: AppColors.sun400),
  grass(fill: AppColors.grass400);

  final Color fill;
  const ProgressBarTone({required this.fill});
}

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    required this.value,
    super.key,
    this.label,
    this.max = 100,
    this.showsValue = false,
    this.tone = ProgressBarTone.grass,
  });

  final int max;
  final int value;
  final String? label;
  final bool showsValue;
  final ProgressBarTone tone;

  double get filledFraction => max <= 0 ? 0 : (value / max).clamp(0, 1);

  @override
  Widget build(BuildContext context) {
    final label = this.label;
    final hasHead = label != null || showsValue;

    return Column(
      spacing: 6,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hasHead)
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(child: Text(label ?? '', style: _labelStyle)),
              if (showsValue) Text('$value / $max', style: _valueStyle),
            ],
          ),
        Container(
          height: _trackHeight,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.surface300,
            borderRadius: AppRadius.small,
            border: Border.all(color: AppColors.surface400, width: AppBorderWidth.thick),
          ),
          child: TweenAnimationBuilder<double>(
            duration: _fillDuration,
            tween: Tween(end: filledFraction),
            builder: (context, fraction, child) => FractionallySizedBox(
              widthFactor: fraction,
              alignment: Alignment.centerLeft,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: tone.fill,
                  border: fraction == 0
                      ? null
                      : const Border(
                          right: BorderSide(color: AppColors.surface400, width: AppBorderWidth.thick),
                        ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
