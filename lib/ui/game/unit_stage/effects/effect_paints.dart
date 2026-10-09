import 'dart:ui';

Color fadedColor(Color color, double opacity) => color.withValues(alpha: opacity.clamp(0.0, 1.0));

void strokeGlowing(Canvas canvas, Path path, {required Color color, required double width, double blur = 0}) {
  final paint = Paint()
    ..color = color
    ..strokeWidth = width
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round;

  if (blur > 0) canvas.drawPath(path, paint..maskFilter = MaskFilter.blur(BlurStyle.normal, blur / 2));
  canvas.drawPath(path, paint..maskFilter = null);
}

void fillGlowing(Canvas canvas, Path path, {required Color color, double blur = 0}) {
  final paint = Paint()..color = color;

  if (blur > 0) canvas.drawPath(path, paint..maskFilter = MaskFilter.blur(BlurStyle.normal, blur / 2));
  canvas.drawPath(path, paint..maskFilter = null);
}

void fillRadialGlow(Canvas canvas, Offset center, {required double radius, required List<Color> colors, List<double>? stops}) {
  canvas.drawRect(
    Rect.fromCircle(center: center, radius: radius),
    Paint()..shader = Gradient.radial(center, radius, colors, stops),
  );
}
