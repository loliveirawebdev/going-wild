import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/splash/widgets/edge_veil.dart';
import 'package:going_wild/ui/splash/widgets/scene_backdrop.dart';
import 'package:going_wild/ui/splash/widgets/splash_logo.dart';

class SplashScene extends StatelessWidget {
  const SplashScene({required this.child, super.key, this.isBlurred = false});

  final Widget child;
  final bool isBlurred;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ColoredBox(
        color: AppColors.wood700,
        child: Stack(
          fit: StackFit.expand,
          children: [
            SceneBackdrop(isBlurred: isBlurred),
            const EdgeVeil(),
            SplashLogo(isVisible: !isBlurred),
            child,
          ],
        ),
      ),
    );
  }
}
