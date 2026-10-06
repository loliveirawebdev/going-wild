import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/game/widgets/set_chips/celebration/spark_painter.dart';

const _poofDuration = Duration(milliseconds: 750);
const _referenceSize = 120.0;
const _lifeFadeStart = 0.92;

const _ringDiameter = 100.0;
const _ringStrokeWidth = 5.0;
const _ringDurationMs = 450.0;

const _puffColor = Color(0xFFF4ECE0);
const _puffStrokeWidth = 3.0;
const _puffDurationMs = 620.0;
const _puffDelayStepMs = 18.0;
const _puffRiseHeight = 14.0;
const _puffShadeOffset = Offset(-6, -8);
const _puffCurve = Cubic(0.2, 0.9, 0.3, 1);

const _sparkSize = 16.0;
const _sparkDurationMs = 550.0;
const _sparkDelayMs = 120.0;
const _sparkDelayStepMs = 40.0;

const _puffs = <({Offset spread, double radius})>[
  (spread: Offset(0, -34), radius: 30),
  (spread: Offset(30, -20), radius: 26),
  (spread: Offset(34, 12), radius: 24),
  (spread: Offset(10, 30), radius: 26),
  (spread: Offset(-22, 26), radius: 24),
  (spread: Offset(-36, -4), radius: 26),
  (spread: Offset(-18, -30), radius: 22),
  (spread: Offset.zero, radius: 34),
];

const _sparkSpreads = <Offset>[Offset(-46, -40), Offset(48, -36), Offset(-52, 22), Offset(50, 26), Offset(0, -58)];

class SummonPoof extends StatefulWidget {
  final double size;
  final VoidCallback onDone;
  const SummonPoof({required this.size, required this.onDone, super.key});

  @override
  State<SummonPoof> createState() => _SummonPoofState();
}

class _SummonPoofState extends State<SummonPoof> with SingleTickerProviderStateMixin {
  late final _poofController = AnimationController(vsync: this, duration: _poofDuration);

  @override
  void initState() {
    super.initState();
    _poofController.forward().whenComplete(() {
      if (mounted) widget.onDone();
    });
  }

  @override
  void dispose() {
    _poofController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        size: Size.square(widget.size),
        painter: _SummonPoofPainter(poof: _poofController, scale: widget.size / _referenceSize),
      ),
    );
  }
}

class _SummonPoofPainter extends CustomPainter {
  final double scale;
  final Animation<double> poof;
  _SummonPoofPainter({required this.poof, required this.scale}) : super(repaint: poof);

  double get _elapsedMs => poof.value * _poofDuration.inMilliseconds;

  double get _lifeOpacity => poof.value <= _lifeFadeStart ? 1 : (1 - poof.value) / (1 - _lifeFadeStart);

  double _progressOf(double delayMs, double durationMs) => ((_elapsedMs - delayMs) / durationMs).clamp(0, 1);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(scale);

    _paintRing(canvas);
    for (final (puffIndex, puff) in _puffs.indexed) {
      final isCenterPuff = puffIndex == _puffs.length - 1;
      _paintPuff(canvas, puff.spread, puff.radius, _progressOf(isCenterPuff ? 0 : puffIndex * _puffDelayStepMs, _puffDurationMs));
    }
    for (final (sparkIndex, spread) in _sparkSpreads.indexed) {
      _paintSpark(canvas, spread, _progressOf(_sparkDelayMs + sparkIndex * _sparkDelayStepMs, _sparkDurationMs));
    }
  }

  void _paintRing(Canvas canvas) {
    final progress = Curves.easeOut.transform(_progressOf(0, _ringDurationMs));
    final opacity = 0.9 * (1 - progress) * _lifeOpacity;
    if (opacity <= 0) return;

    canvas.save();
    canvas.scale(0.2 + 1.3 * progress);
    canvas.drawCircle(
      Offset.zero,
      (_ringDiameter - _ringStrokeWidth) / 2,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _ringStrokeWidth
        ..color = AppColors.surface100.withValues(alpha: opacity),
    );
    canvas.restore();
  }

  void _paintPuff(Canvas canvas, Offset spread, double radius, double progress) {
    final opacity = _puffOpacityAt(progress) * _lifeOpacity;
    if (progress <= 0 || opacity <= 0) return;

    final ({Offset offset, double scale}) motion;
    if (progress <= 0.55) {
      final eased = _puffCurve.transform(progress / 0.55);
      motion = (offset: spread * eased, scale: 0.1 + 0.9 * eased);
    } else {
      final eased = _puffCurve.transform((progress - 0.55) / 0.45);
      final finalOffset = spread * 1.35 - const Offset(0, _puffRiseHeight);
      motion = (offset: Offset.lerp(spread, finalOffset, eased)!, scale: 1 - 0.85 * eased);
    }

    canvas.save();
    canvas.translate(motion.offset.dx, motion.offset.dy);
    canvas.scale(motion.scale);

    final circle = Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: radius));
    final shade = Path.combine(PathOperation.difference, circle, circle.shift(_puffShadeOffset));
    canvas.drawPath(circle, Paint()..color = _puffColor.withValues(alpha: opacity));
    canvas.drawPath(shade, Paint()..color = AppColors.outline.withValues(alpha: 0.18 * opacity));
    canvas.drawCircle(
      Offset.zero,
      radius - _puffStrokeWidth / 2,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _puffStrokeWidth
        ..color = AppColors.outline.withValues(alpha: opacity),
    );
    canvas.restore();
  }

  double _puffOpacityAt(double progress) {
    if (progress <= 0.25) return _puffCurve.transform(progress / 0.25);
    return 1 - _puffCurve.transform((progress - 0.25) / 0.75);
  }

  void _paintSpark(Canvas canvas, Offset spread, double progress) {
    if (progress <= 0 || progress >= 1) return;

    final eased = Curves.easeOut.transform(progress);
    final fadeIn = Curves.easeOut.transform((progress / 0.4).clamp(0, 1));
    final fadeOut = Curves.easeOut.transform(((progress - 0.4) / 0.6).clamp(0, 1));
    final opacity = (progress <= 0.4 ? fadeIn : 1 - fadeOut) * _lifeOpacity;
    if (opacity <= 0 || eased <= 0) return;

    canvas.save();
    canvas.translate(spread.dx * eased, spread.dy * eased);
    canvas.rotate(pi / 2 * eased);
    canvas.scale(eased);
    canvas.translate(-_sparkSize / 2, -_sparkSize / 2);
    SparkPainter(
      fillColor: AppColors.sun400.withValues(alpha: opacity),
      strokeColor: AppColors.outline.withValues(alpha: opacity),
    ).paint(canvas, const Size.square(_sparkSize));
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SummonPoofPainter oldDelegate) => oldDelegate.scale != scale || oldDelegate.poof != poof;
}
