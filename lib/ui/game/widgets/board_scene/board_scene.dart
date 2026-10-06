import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/painted_scene.dart';
import 'package:going_wild/ui/game/widgets/board_scene/board_scene_layout.dart';

const _grassFadeStart = 1 - 0.22;

const _grassFade = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  stops: [_grassFadeStart, 1],
  colors: [Color(0x00557949), AppColors.sceneGrass],
);

class BoardScene extends StatelessWidget {
  final Widget Function(BuildContext context, double scale)? overlayBuilder;
  const BoardScene({super.key, this.overlayBuilder});

  @override
  Widget build(BuildContext context) {
    final overlayBuilder = this.overlayBuilder;

    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = BoardSceneLayout.scaleFor(constraints.maxWidth);

        return SizedBox.fromSize(
          size: BoardSceneLayout.imageSize * scale,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(PaintedScene.board.assetPath, fit: BoxFit.fill),
              const DecoratedBox(decoration: BoxDecoration(gradient: _grassFade)),
              ?overlayBuilder?.call(context, scale),
            ],
          ),
        );
      },
    );
  }
}
