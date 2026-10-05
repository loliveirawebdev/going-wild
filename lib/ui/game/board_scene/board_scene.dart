import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/board/board.dart';
import 'package:going_wild/domain/models/board/board_side.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/painted_scene.dart';
import 'package:going_wild/ui/game/board_scene/board_scene_layout.dart';

const _grassFadeStart = 1 - 0.22;

const _grassFade = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  stops: [_grassFadeStart, 1],
  colors: [Color(0x0057734F), AppColors.sceneGrass],
);

const _debugBorderWidth = 2.0;
const _debugFillOpacity = 0.35;
const _debugLabelFontSize = 12.0;

class BoardScene extends StatelessWidget {
  final Board board;
  const BoardScene({required this.board, super.key});

  @override
  Widget build(BuildContext context) {
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
              CustomPaint(
                painter: _CellsDebugPainter(
                  board: board,
                  scale: scale,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CellsDebugPainter extends CustomPainter {
  final Board board;
  final double scale;
  _CellsDebugPainter({required this.board, required this.scale});

  Color _colorOf(BoardSide side) => switch (side) {
    BoardSide.team => AppColors.grass400,
    BoardSide.enemy => AppColors.barn400,
    BoardSide.shared => AppColors.sun400,
  };

  @override
  void paint(Canvas canvas, Size size) {
    for (final position in board.allPositions) {
      final cellRect = BoardSceneLayout.cellRectOf(board, position, scale: scale);
      final hexagon = BoardSceneLayout.hexagonPathIn(cellRect);
      final color = _colorOf(board.rows[position.row].side);

      canvas.drawPath(hexagon, Paint()..color = color.withValues(alpha: _debugFillOpacity));

      canvas.drawPath(
        hexagon,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = _debugBorderWidth,
      );

      final label = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          text: '${position.row},${position.column}',
          style: const TextStyle(color: AppColors.onPrimary, fontSize: _debugLabelFontSize, fontWeight: FontWeight.w800),
        ),
      )..layout();

      label.paint(canvas, cellRect.center - Offset(label.width / 2, label.height / 2));
    }
  }

  @override
  bool shouldRepaint(_CellsDebugPainter oldDelegate) => oldDelegate.scale != scale || oldDelegate.board != board;
}
