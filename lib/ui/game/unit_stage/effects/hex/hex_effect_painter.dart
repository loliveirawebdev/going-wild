import 'dart:math';
import 'dart:ui';

import 'package:going_wild/domain/models/character/sprite/hex_effect.dart';
import 'package:going_wild/ui/game/unit_stage/effects/effect_paints.dart';
import 'package:going_wild/ui/game/unit_stage/effects/hex/effect_hexagon.dart';

const _white = Color(0xFFFFFFFF);

typedef _Wisp = ({double turn, double phase, double size});

final List<_Wisp> _wisps = List.unmodifiable([
  for (var index = 0; index < 22; index++) (turn: (index * 0.618) % 1, phase: (index * 0.37) % 1, size: 0.7 + ((index * 7) % 5) / 10),
]);

class HexEffectPainter {
  const HexEffectPainter({required this.kind, required this.color});

  final Color color;
  final HexEffectKind kind;

  void paintGround(Canvas canvas, Offset center, {required double seconds, required double intensity}) {
    switch (kind) {
      case HexEffectKind.neon:
        _paintNeonGround(canvas, center, seconds, intensity);
      case HexEffectKind.inner:
        _paintInnerGround(canvas, center, seconds, intensity);
      case HexEffectKind.paint:
        _paintPaintedGround(canvas, center, seconds, intensity);
      case HexEffectKind.mist:
        _paintMistGround(canvas, center, seconds, intensity);
      case HexEffectKind.aura:
        _paintAuraGround(canvas, center, intensity);
      case HexEffectKind.pulse:
        _paintPulseGround(canvas, center, seconds, intensity);
    }
  }

  void paintFront(Canvas canvas, Offset center, {required double seconds, required double intensity}) {
    switch (kind) {
      case HexEffectKind.mist:
        _paintWisps(canvas, center, seconds, intensity, isFront: true);
      case HexEffectKind.neon:
        _paintNeonSparks(canvas, center, seconds, intensity);
      case HexEffectKind.inner || HexEffectKind.paint || HexEffectKind.aura || HexEffectKind.pulse:
        return;
    }
  }

  void _paintNeonGround(Canvas canvas, Offset center, double seconds, double intensity) {
    final pulse = 0.75 + 0.25 * sin(seconds * 3.2);
    canvas.drawPath(EffectHexagon.pathAround(center, 1), Paint()..color = fadedColor(color, 0.10 * intensity * pulse));

    final rim = EffectHexagon.pathAround(center, 0.97);
    for (final (width, opacity, blur) in const [(14.0, 0.18, 28.0), (7.0, 0.45, 16.0), (3.0, 0.95, 6.0)]) {
      strokeGlowing(canvas, rim, color: fadedColor(color, opacity * intensity * pulse), width: width, blur: blur);
    }

    strokeGlowing(canvas, rim, color: fadedColor(_white, 0.55 * intensity * pulse), width: 1.2);
  }

  void _paintInnerGround(Canvas canvas, Offset center, double seconds, double intensity) {
    final pulse = 0.8 + 0.2 * sin(seconds * 2.4);
    final outline = EffectHexagon.pathAround(center, 0.98);

    canvas.save();
    canvas.clipPath(outline);
    for (var ring = 0; ring < 6; ring++) {
      strokeGlowing(
        canvas,
        EffectHexagon.pathAround(center, 0.98 * (1 - ring * 0.07)),
        color: fadedColor(color, (0.38 - ring * 0.055) * intensity * pulse),
        width: 14,
        blur: 18,
      );
    }

    for (var blob = 0; blob < 5; blob++) {
      final edgePoint = EffectHexagon.edgePointAround(center, 0.8, (blob / 5 + seconds * 0.03) % 1);
      fillRadialGlow(canvas, edgePoint, radius: 40, colors: [fadedColor(color, 0.22 * intensity * pulse), fadedColor(color, 0)]);
    }
    canvas.restore();

    strokeGlowing(canvas, outline, color: fadedColor(color, 0.55 * intensity * pulse), width: 2);
  }

  void _paintPaintedGround(Canvas canvas, Offset center, double seconds, double intensity) {
    final pulse = 0.75 + 0.25 * sin(seconds * 1.8);
    for (var coat = 0; coat < 4; coat++) {
      fillGlowing(canvas, EffectHexagon.pathAround(center, 1 - coat * 0.04), color: fadedColor(color, 0.09 * intensity * pulse), blur: 10);
    }

    canvas.save();
    canvas.clipPath(EffectHexagon.pathAround(center, 1));
    fillRadialGlow(canvas, center, radius: 70, colors: [fadedColor(_white, 0.18 * intensity * pulse), fadedColor(_white, 0)]);
    canvas.restore();
  }

  void _paintMistGround(Canvas canvas, Offset center, double seconds, double intensity) {
    canvas.save();
    canvas.clipPath(EffectHexagon.pathAround(center, 1));
    for (var ring = 0; ring < 4; ring++) {
      strokeGlowing(
        canvas,
        EffectHexagon.pathAround(center, 1 - ring * 0.06),
        color: fadedColor(color, (0.30 - ring * 0.06) * intensity),
        width: 12,
        blur: 16,
      );
    }
    canvas.restore();

    _paintWisps(canvas, center, seconds, intensity, isFront: false);
  }

  void _paintAuraGround(Canvas canvas, Offset center, double intensity) {
    canvas.save();
    canvas.clipPath(EffectHexagon.pathAround(center, 1));
    fillRadialGlow(
      canvas,
      center + const Offset(0, 6),
      radius: 75,
      stops: const [0, 0.6, 1],
      colors: [fadedColor(color, 0.42 * intensity), fadedColor(color, 0.16 * intensity), fadedColor(color, 0)],
    );
    canvas.restore();

    strokeGlowing(canvas, EffectHexagon.pathAround(center, 0.97), color: fadedColor(color, 0.35 * intensity), width: 2.5, blur: 10);
  }

  void _paintPulseGround(Canvas canvas, Offset center, double seconds, double intensity) {
    canvas.save();
    canvas.clipPath(EffectHexagon.pathAround(center, 1));
    for (var wave = 0; wave < 3; wave++) {
      final progress = (seconds * 0.55 + wave / 3) % 1;
      final ring = EffectHexagon.pathAround(center, 0.15 + progress * 0.95);
      strokeGlowing(canvas, ring, color: fadedColor(color, (1 - progress) * 0.75 * intensity), width: 6 - 4 * progress, blur: 12);
      canvas.drawPath(ring, Paint()..color = fadedColor(color, (1 - progress) * 0.07 * intensity));
    }
    canvas.restore();

    final hit = max(0.0, sin(seconds * 0.55 * 2 * pi));
    strokeGlowing(
      canvas,
      EffectHexagon.pathAround(center, 0.97),
      color: fadedColor(color, (0.4 + 0.4 * hit) * intensity),
      width: 3,
      blur: 14,
    );
  }

  void _paintWisps(Canvas canvas, Offset center, double seconds, double intensity, {required bool isFront}) {
    for (final wisp in _wisps) {
      final edgePoint = EffectHexagon.edgePointAround(center, 0.92, wisp.turn);
      if ((edgePoint.dy > center.dy) != isFront) continue;

      final progress = (seconds * 0.22 + wisp.phase) % 1;
      final wispCenter = Offset(edgePoint.dx + sin(progress * 6 + wisp.turn * 10) * 8, edgePoint.dy - progress * 95);
      final opacity = sin(progress * pi) * 0.62 * intensity;

      fillRadialGlow(
        canvas,
        wispCenter,
        radius: (12 + 24 * progress) * wisp.size,
        colors: [fadedColor(color, opacity), fadedColor(color, 0)],
      );
    }
  }

  void _paintNeonSparks(Canvas canvas, Offset center, double seconds, double intensity) {
    for (var spark = 0; spark < 6; spark++) {
      final edgePoint = EffectHexagon.edgePointAround(center, 0.97, (spark / 6 + 0.04) % 1);
      if (edgePoint.dy < center.dy) continue;

      final progress = (seconds * 0.35 + spark / 6) % 1;
      canvas.drawCircle(
        edgePoint - Offset(0, progress * 26),
        2.2,
        Paint()..color = fadedColor(color, (1 - progress) * 0.9 * intensity),
      );
    }
  }
}
