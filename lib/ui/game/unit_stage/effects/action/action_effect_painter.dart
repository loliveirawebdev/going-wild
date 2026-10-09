import 'dart:math';
import 'dart:ui';

import 'package:going_wild/ui/game/unit_stage/effects/effect_paints.dart';

const _white = Color(0xFFFFFFFF);
const _cream = Color(0xFFF3F1EA);
const _fireCore = Color(0xFFFFF8D0);
const _starOutline = Color.fromRGBO(60, 40, 10, 0.6);
const _rockOutline = Color.fromRGBO(40, 30, 20, 0.8);
const _neutralDust = Color(0xFFD8C7A8);

typedef DustMote = ({Offset origin, double bornAt, double drift, double size});
typedef TrailSpot = ({Offset center, double radius, double opacity});

abstract final class ActionEffectPainter {
  static void paintStunStars(Canvas canvas, Offset headTop, {required double seconds, required Color color, required double opacity}) {
    if (opacity <= 0) return;

    for (var star = 0; star < 3; star++) {
      final angle = seconds * 4 + star * 2.094;
      final isFront = sin(angle) > 0;
      final radius = isFront ? 8.0 : 6.0;
      final center = headTop + Offset(30 * cos(angle), -6 + 9 * sin(angle));
      final path = _starPath(center, radius: radius, spin: seconds * 2);
      final starOpacity = opacity * (isFront ? 1 : 0.7);

      fillGlowing(canvas, path, color: fadedColor(color, starOpacity), blur: 10);
      strokeGlowing(canvas, path, color: fadedColor(_starOutline, _starOutline.a * starOpacity), width: 1.2);
    }

    final orbit = Path()..addOval(Rect.fromCenter(center: headTop - const Offset(0, 6), width: 60, height: 18));
    _strokeDashed(canvas, orbit, color: fadedColor(color, opacity * 0.5), width: 2, dash: 4, gap: 6);
  }

  static void paintDust(Canvas canvas, List<DustMote> motes, {required double seconds, required Color color}) {
    final dustColor = color == _white ? _neutralDust : color;

    for (final mote in motes) {
      final progress = (seconds - mote.bornAt) / 0.7;
      if (progress < 0 || progress > 1) continue;

      canvas.drawCircle(
        mote.origin + Offset(mote.drift * progress, -14 * progress),
        (6 + 16 * progress) * mote.size,
        Paint()..color = fadedColor(dustColor, (1 - progress) * 0.7),
      );
    }
  }

  static void paintImpactFlash(Canvas canvas, Offset center, {required double progress, required Color color}) {
    if (progress < 0 || progress > 1) return;

    final rayPaint = Paint()
      ..strokeWidth = 4
      ..color = fadedColor(_white, 1 - progress);

    for (var ray = 0; ray < 8; ray++) {
      final angle = ray * pi / 4;
      final direction = Offset(cos(angle), sin(angle) * 0.7);
      canvas.drawLine(center + direction * (10 + 20 * progress), center + direction * (24 + 26 * progress), rayPaint);
    }

    canvas.drawCircle(center, 14 + 18 * progress, Paint()..color = fadedColor(color, (1 - progress) * 0.6));
  }

  static void paintSmokePuff(Canvas canvas, Offset ground, {required double progress, required Color color}) {
    if (progress < 0 || progress > 1) return;

    for (var bubble = 0; bubble < 9; bubble++) {
      final angle = bubble / 9 * 2 * pi;
      final spread = 18 + 46 * progress;
      final bubbleColor = bubble.isOdd ? _cream : fadedColor(color, 0.9);

      canvas.drawCircle(
        ground + Offset(cos(angle) * spread * 0.8, -40 + sin(angle) * spread * 0.5 - progress * 10),
        20 - 10 * progress,
        Paint()..color = fadedColor(bubbleColor, bubbleColor.a * (1 - progress) * 0.85),
      );
    }
  }

  static void paintFireBall(Canvas canvas, Offset center, {required Color color, required List<TrailSpot> trail}) {
    for (final spot in trail) {
      canvas.drawCircle(spot.center, spot.radius, Paint()..color = fadedColor(color, spot.opacity * 0.6));
    }

    canvas.drawCircle(
      center,
      18,
      Paint()..shader = Gradient.radial(center, 18, [_fireCore, color, fadedColor(color, 0)], const [0, 0.4, 1]),
    );
  }

  static void paintSpinningRock(Canvas canvas, Offset center, {required double seconds, required Color color}) {
    final outline = Path();
    for (var corner = 0; corner < 7; corner++) {
      final angle = corner / 7 * 2 * pi + seconds * 12;
      final radius = 8.0 + (corner * 5) % 3;
      final point = center + Offset(cos(angle), sin(angle)) * radius;
      corner == 0 ? outline.moveTo(point.dx, point.dy) : outline.lineTo(point.dx, point.dy);
    }
    outline.close();

    canvas.drawPath(outline, Paint()..color = color);
    strokeGlowing(canvas, outline, color: _rockOutline, width: 2);
  }

  static void paintWebPellet(Canvas canvas, Offset center, {required Color color}) {
    canvas.drawCircle(center, 7, Paint()..color = color);
  }

  static void paintWeb(Canvas canvas, Offset center, {required double progress, required Color color, required double opacity}) {
    if (opacity <= 0 || progress < 0) return;

    final spread = min(1.0, progress);
    final threadPaint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..color = fadedColor(color, opacity * 0.9);

    for (var spoke = 0; spoke < 8; spoke++) {
      final angle = spoke * pi / 4;
      canvas.drawLine(center, center + Offset(cos(angle) * 60, sin(angle) * 36) * spread, threadPaint);
    }

    for (var ring = 1; ring <= 3; ring++) {
      final points = [
        for (var spoke = 0; spoke <= 8; spoke++) center + Offset(cos(spoke * pi / 4) * 20 * ring, sin(spoke * pi / 4) * 12 * ring) * spread,
      ];
      canvas.drawPath(Path()..addPolygon(points, false), threadPaint);
    }
  }

  static void paintBeam(Canvas canvas, Offset from, Offset to, {required double progress, required Color color}) {
    if (progress < 0 || progress > 1) return;

    final growth = min(1.0, progress / 0.3);
    final fade = progress > 0.6 ? 1 - (progress - 0.6) / 0.4 : 1.0;
    final end = Offset.lerp(from, to, growth)!;

    final glowPaint = Paint()
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round
      ..color = fadedColor(color, 0.45 * fade);

    canvas.drawLine(from, end, glowPaint..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9));
    canvas.drawLine(from, end, glowPaint..maskFilter = null);
    canvas.drawLine(
      from,
      end,
      Paint()
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..color = fadedColor(_white, fade),
    );
  }

  static Path _starPath(Offset center, {required double radius, required double spin}) {
    final points = [
      for (var point = 0; point < 10; point++)
        center + Offset(cos(point * pi / 5 - pi / 2 + spin), sin(point * pi / 5 - pi / 2 + spin)) * (point.isOdd ? radius * 0.45 : radius),
    ];

    return Path()..addPolygon(points, true);
  }

  static void _strokeDashed(
    Canvas canvas,
    Path path, {
    required Color color,
    required double width,
    required double dash,
    required double gap,
  }) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;

    for (final metric in path.computeMetrics()) {
      for (var start = 0.0; start < metric.length; start += dash + gap) {
        canvas.drawPath(metric.extractPath(start, min(start + dash, metric.length)), paint);
      }
    }
  }
}
