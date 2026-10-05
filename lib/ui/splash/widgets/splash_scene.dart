import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/painted_scene.dart';

const _veil = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  stops: [0, 0.16, 0.72, 1],
  colors: [Color(0x4D6B3E1F), Color(0x006B3E1F), Color(0x006B3E1F), Color(0x476B3E1F)],
);

class SplashScene extends StatelessWidget {
  const SplashScene({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ColoredBox(
        color: AppColors.wood700,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(PaintedScene.splash.assetPath, fit: BoxFit.cover, gaplessPlayback: true),
            const IgnorePointer(
              child: DecoratedBox(decoration: BoxDecoration(gradient: _veil)),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
