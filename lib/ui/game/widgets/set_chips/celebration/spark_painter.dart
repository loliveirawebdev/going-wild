import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';

const _sparkStrokeWidth = 2.0;
const _sparkViewBoxSize = 24.0;

class SparkPainter extends CustomPainter {
  const SparkPainter();

  static final _sparkPath = Path()
    ..moveTo(12, 2)
    ..lineTo(14.6, 8.8)
    ..lineTo(21.5, 12)
    ..lineTo(14.6, 14.9)
    ..lineTo(12, 22)
    ..lineTo(9.4, 14.9)
    ..lineTo(2.5, 12)
    ..lineTo(9.4, 8.8)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / _sparkViewBoxSize);
    canvas.drawPath(_sparkPath, Paint()..color = AppColors.sun400);
    canvas.drawPath(
      _sparkPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = AppColors.sun600
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = _sparkStrokeWidth,
    );
  }

  @override
  bool shouldRepaint(SparkPainter oldDelegate) => false;
}
