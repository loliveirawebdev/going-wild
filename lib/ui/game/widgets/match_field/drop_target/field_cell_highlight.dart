import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/game/widgets/board_scene/board_scene_layout.dart';

enum FieldCellHighlight {
  none(color: AppColors.grass400, borderColor: AppColors.grass400, fillOpacity: 0, borderWidth: 0),
  available(color: AppColors.grass400, borderColor: AppColors.grass400, fillOpacity: 0.28, borderWidth: 2.5),
  hoveredAvailable(color: AppColors.sun400, borderColor: AppColors.sun600, fillOpacity: 0.65, borderWidth: 4),
  hoveredForbidden(color: AppColors.barn400, borderColor: AppColors.barn600, fillOpacity: 0.5, borderWidth: 4);

  final Color color;
  final Color borderColor;
  final double borderWidth;
  final double fillOpacity;
  const FieldCellHighlight({required this.color, required this.borderColor, required this.borderWidth, required this.fillOpacity});
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
        ..style = PaintingStyle.stroke
        ..color = highlight.borderColor
        ..strokeWidth = highlight.borderWidth,
    );
  }

  @override
  bool shouldRepaint(FieldCellHighlightPainter oldDelegate) => oldDelegate.highlight != highlight;
}
