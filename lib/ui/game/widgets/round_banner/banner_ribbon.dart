import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';

const _viewBoxSize = Size(340, 98);
const _strokeWidth = 4.0;
const _bandDepth = 5.0;
const _titleTopFraction = 0.12;
const _titleHeightFraction = 0.65;
const _titleSizeFraction = 0.11;
const _minimumTitleSize = 28.0;
const _maximumTitleSize = 40.0;
const _defeatTilt = -3 * pi / 180;
const _entranceDuration = Duration(milliseconds: 550);

enum BannerRibbonTone {
  go(fillColor: AppColors.grass400, darkColor: AppColors.grass600, titleColor: AppColors.ink),
  victory(fillColor: AppColors.sun400, darkColor: AppColors.sun600, titleColor: AppColors.ink),
  defeat(fillColor: AppColors.barn600, darkColor: AppColors.barn800, titleColor: AppColors.onPrimary);

  final Color fillColor;
  final Color darkColor;
  final Color titleColor;
  const BannerRibbonTone({required this.fillColor, required this.darkColor, required this.titleColor});
}

class BannerRibbon extends StatelessWidget {
  final String title;
  final BannerRibbonTone tone;
  const BannerRibbon({required this.tone, required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    final isMotionReduced = MediaQuery.disableAnimationsOf(context);
    final isDefeat = tone == BannerRibbonTone.defeat;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final titleSize = (width * _titleSizeFraction).clamp(_minimumTitleSize, _maximumTitleSize);
        final ribbon = AspectRatio(
          aspectRatio: _viewBoxSize.width / _viewBoxSize.height,
          child: CustomPaint(
            painter: _RibbonPainter(tone: tone),
            child: FractionallySizedBox(
              alignment: Alignment.topCenter,
              heightFactor: _titleHeightFraction,
              child: Padding(
                padding: EdgeInsets.only(top: width / _viewBoxSize.width * _viewBoxSize.height * _titleTopFraction),
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      height: 1,
                      letterSpacing: 0.5,
                      fontSize: titleSize,
                      color: tone.titleColor,
                      fontFamily: AppFonts.display,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        if (isMotionReduced) return Transform.rotate(angle: isDefeat ? _defeatTilt : 0, child: ribbon);

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: _entranceDuration,
          curve: const Cubic(0.2, 1.5, 0.4, 1),
          child: ribbon,
          builder: (context, progress, child) {
            final opacity = progress.clamp(0.0, 1.0);
            if (isDefeat) {
              return Opacity(
                opacity: opacity,
                child: Transform.translate(
                  offset: Offset(0, -120 * (1 - progress)),
                  child: Transform.rotate(angle: _defeatTilt + 7 * pi / 180 * (1 - progress), child: child),
                ),
              );
            }

            return Opacity(
              opacity: opacity,
              child: Transform.rotate(
                angle: -6 * pi / 180 * (1 - progress),
                child: Transform.scale(scale: 0.4 + 0.6 * progress, child: child),
              ),
            );
          },
        );
      },
    );
  }
}

class _RibbonPainter extends CustomPainter {
  final BannerRibbonTone tone;
  const _RibbonPainter({required this.tone});

  static final _leftTail = Path()
    ..moveTo(46, 40)
    ..lineTo(6, 40)
    ..lineTo(22, 63)
    ..lineTo(6, 86)
    ..lineTo(46, 86)
    ..close();

  static final _rightTail = Path()
    ..moveTo(294, 40)
    ..lineTo(334, 40)
    ..lineTo(318, 63)
    ..lineTo(334, 86)
    ..lineTo(294, 86)
    ..close();

  static final _leftFold = Path()
    ..moveTo(30, 74)
    ..lineTo(46, 86)
    ..lineTo(46, 70)
    ..close();

  static final _rightFold = Path()
    ..moveTo(310, 74)
    ..lineTo(294, 86)
    ..lineTo(294, 70)
    ..close();

  static final _band = RRect.fromRectAndRadius(const Rect.fromLTWH(30, 12, 280, 64), const Radius.circular(12));

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / _viewBoxSize.width);
    final edgeColor = Color.lerp(tone.darkColor, AppColors.ink, 0.35)!;
    final stroke = Paint()
      ..color = edgeColor
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = _strokeWidth;

    for (final tail in [_leftTail, _rightTail]) {
      canvas.drawPath(tail, Paint()..color = tone.darkColor);
      canvas.drawPath(tail, stroke);
    }

    for (final fold in [_leftFold, _rightFold]) {
      canvas.drawPath(fold, Paint()..color = edgeColor);
    }

    canvas.drawRRect(_band.shift(const Offset(0, _bandDepth)), Paint()..color = tone.darkColor);
    canvas.drawRRect(_band, Paint()..color = tone.fillColor);
    canvas.drawRRect(_band, stroke);
  }

  @override
  bool shouldRepaint(_RibbonPainter oldDelegate) => oldDelegate.tone != tone;
}
