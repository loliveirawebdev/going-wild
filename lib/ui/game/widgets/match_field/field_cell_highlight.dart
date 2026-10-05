import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/game/widgets/board_scene/board_scene_layout.dart';

const _borderWidth = 2.5;

enum FieldCellHighlight {
  none(color: AppColors.grass400, fillOpacity: 0),
  available(color: AppColors.grass400, fillOpacity: 0.28),
  hoveredAvailable(color: AppColors.grass400, fillOpacity: 0.55),
  hoveredForbidden(color: AppColors.barn400, fillOpacity: 0.5);

  final Color color;
  final double fillOpacity;
  const FieldCellHighlight({required this.color, required this.fillOpacity});
}

class FieldCellHighlightPainter extends CustomPainter {
  final FieldCellHighlight highlight;
  const FieldCellHighlightPainter({required this.highlight});

  @override
  void paint(Canvas canvas, Size size) {
    if (highlight == FieldCellHighlight.none) return;
    final hexagon = BoardSceneLayout.hexagonPathIn(Offset.zero & size);

    canvas.drawPath(hexagon, Paint()..color = highlight.color.withValues(alpha: highlight.fillOpacity));
    canvas.drawPath(
      hexagon,
      Paint()
        ..color = highlight.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = _borderWidth,
    );
  }

  @override
  bool shouldRepaint(FieldCellHighlightPainter oldDelegate) => oldDelegate.highlight != highlight;
}
