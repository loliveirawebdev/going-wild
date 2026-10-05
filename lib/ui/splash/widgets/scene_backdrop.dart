import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/painted_scene.dart';

const _maximumBlurSigma = 4.0;
const _maximumShadeOpacity = 0.5;
const _focusDuration = Duration(milliseconds: 300);

class SceneBackdrop extends StatelessWidget {
  const SceneBackdrop({required this.isBlurred, super.key});

  final bool isBlurred;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      curve: Curves.easeOut,
      duration: _focusDuration,
      tween: Tween(end: isBlurred ? 1 : 0),
      builder: (context, blurAmount, scene) => Stack(
        fit: StackFit.expand,
        children: [
          ImageFiltered(
            enabled: blurAmount > 0,
            imageFilter: ImageFilter.blur(sigmaX: _maximumBlurSigma * blurAmount, sigmaY: _maximumBlurSigma * blurAmount),
            child: scene,
          ),
          ColoredBox(color: AppColors.wood700.withValues(alpha: _maximumShadeOpacity * blurAmount)),
        ],
      ),
      child: Image.asset(PaintedScene.splash.assetPath, fit: BoxFit.cover, gaplessPlayback: true),
    );
  }
}
