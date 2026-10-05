import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';

const _starViewBoxSize = 24.0;
const _starStrokeWidth = 2.2;
const _starOverlapWidthFactor = 0.88;
const _crownLift = 0.12;
const _crownScale = 1.12;

class Stars extends StatelessWidget {
  const Stars({required this.count, required this.semanticLabel, super.key, this.size = 18});

  final int count;
  final double size;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final star = SizedBox.square(
      dimension: size,
      child: const CustomPaint(painter: _StarPainter()),
    );

    return Semantics(
      container: true,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var starIndex = 0; starIndex < count; starIndex++)
              Align(
                widthFactor: _starOverlapWidthFactor,
                child: count == 3 && starIndex == 1
                    ? Transform.translate(
                        offset: Offset(0, -size * _crownLift),
                        child: Transform.scale(scale: _crownScale, child: star),
                      )
                    : star,
              ),
          ],
        ),
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  const _StarPainter();

  static final _starPath = Path()
    ..moveTo(12, 2.5)
    ..lineTo(14.9, 8.5)
    ..lineTo(21.5, 9.3)
    ..lineTo(16.6, 13.8)
    ..lineTo(17.9, 20.3)
    ..lineTo(12, 17)
    ..lineTo(6.1, 20.3)
    ..lineTo(7.4, 13.8)
    ..lineTo(2.5, 9.3)
    ..lineTo(9.1, 8.5)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / _starViewBoxSize);
    canvas.drawPath(_starPath, Paint()..color = AppColors.sun400);
    canvas.drawPath(
      _starPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = AppColors.sun600
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = _starStrokeWidth,
    );
  }

  @override
  bool shouldRepaint(_StarPainter oldDelegate) => false;
}
