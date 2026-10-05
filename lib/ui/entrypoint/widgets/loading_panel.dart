import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_shadows.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';

const _maxPanelWidth = 290.0;
const _trackHeight = 20.0;
const _minimumFillWidth = 14.0;
const _stripePeriod = 28.0;
const _halfStripePeriod = _stripePeriod / 2;
const _fillDuration = Duration(milliseconds: 300);
const _stripesLoopDuration = Duration(milliseconds: 800);

const _loadingLabelStyle = TextStyle(
  fontSize: 14,
  height: 18 / 14,
  color: AppColors.ink,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w800,
);

const _percentageStyle = TextStyle(
  fontSize: 18,
  color: AppColors.ink,
  fontFamily: AppFonts.display,
  fontWeight: FontWeight.w400,
);

const _tipStyle = TextStyle(
  fontSize: 13,
  height: 18 / 13,
  color: AppColors.inkMuted,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w600,
);

class LoadingPanel extends StatelessWidget {
  const LoadingPanel({
    required this.tip,
    required this.tipLabel,
    required this.loadingLabel,
    required this.progressPercentage,
    super.key,
  });

  final String tip;
  final String tipLabel;
  final String loadingLabel;
  final int progressPercentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: _maxPanelWidth),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3, horizontal: AppSpacing.space4),
      decoration: BoxDecoration(
        borderRadius: AppRadius.large,
        boxShadow: AppShadows.float,
        color: AppColors.surface100.withValues(alpha: 0.94),
        border: Border.all(color: AppColors.surface400, width: AppBorderWidth.thick),
      ),
      child: Column(
        spacing: AppSpacing.space2,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            spacing: AppSpacing.space2,
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Expanded(
                child: Text(loadingLabel, maxLines: 1, overflow: TextOverflow.ellipsis, style: _loadingLabelStyle),
              ),
              Text('$progressPercentage%', style: _percentageStyle),
            ],
          ),
          _StripedLoadingBar(filledFraction: progressPercentage / 100),
          Text.rich(
            style: _tipStyle,
            TextSpan(
              children: [
                TextSpan(
                  text: '$tipLabel ',
                  style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w800),
                ),
                TextSpan(text: tip),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StripedLoadingBar extends StatefulWidget {
  const _StripedLoadingBar({required this.filledFraction});

  final double filledFraction;

  @override
  State<_StripedLoadingBar> createState() => _StripedLoadingBarState();
}

class _StripedLoadingBarState extends State<_StripedLoadingBar> with SingleTickerProviderStateMixin {
  late final _stripesController = AnimationController(vsync: this, duration: _stripesLoopDuration)..repeat();

  @override
  void dispose() {
    _stripesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _trackHeight,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface300,
        borderRadius: AppRadius.pill,
        border: Border.all(color: AppColors.surface400, width: AppBorderWidth.thick),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Align(
          alignment: Alignment.centerLeft,
          child: AnimatedContainer(
            curve: Curves.easeOut,
            height: double.infinity,
            duration: _fillDuration,
            clipBehavior: Clip.antiAlias,
            width: max(_minimumFillWidth, constraints.maxWidth * widget.filledFraction.clamp(0, 1)),
            decoration: const BoxDecoration(
              borderRadius: AppRadius.pill,
              border: Border(
                right: BorderSide(color: AppColors.surface400, width: AppBorderWidth.thick),
              ),
            ),
            child: CustomPaint(
              painter: _StripesPainter(shift: _stripesController),
              child: const SizedBox.expand(),
            ),
          ),
        ),
      ),
    );
  }
}

class _StripesPainter extends CustomPainter {
  _StripesPainter({required this.shift}) : super(repaint: shift);

  final Animation<double> shift;

  static final _lightStripe = Color.lerp(AppColors.grass400, AppColors.surface100, 0.25)!;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.grass400);

    final lightStripePaint = Paint()..color = _lightStripe;
    final offset = shift.value * _stripePeriod;

    for (var stripeStart = -_stripePeriod - size.height; stripeStart < size.width + _stripePeriod; stripeStart += _stripePeriod) {
      final left = stripeStart + offset;
      final stripe = Path()
        ..moveTo(left, size.height)
        ..lineTo(left + _halfStripePeriod, size.height)
        ..lineTo(left + _halfStripePeriod + size.height, 0)
        ..lineTo(left + size.height, 0)
        ..close();

      canvas.drawPath(stripe, lightStripePaint);
    }
  }

  @override
  bool shouldRepaint(_StripesPainter oldDelegate) => false;
}
