import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';

const _seamFadeHeight = 48.0;

class SceneTopFill extends StatelessWidget {
  final double height;
  const SceneTopFill({required this.height, super.key});

  @override
  Widget build(BuildContext context) {
    final totalHeight = height + _seamFadeHeight;

    return IgnorePointer(
      child: SizedBox(
        height: totalHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter,
              stops: [0, height / totalHeight, 1],
              colors: [AppColors.sceneNight, AppColors.sceneForest, AppColors.sceneForest.withValues(alpha: 0)],
            ),
          ),
        ),
      ),
    );
  }
}
