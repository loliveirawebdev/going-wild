import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';

const _flightDuration = Duration(milliseconds: 260);
const _pebbleDiameter = 4.0;
const _arcHeightToDistance = 0.18;

class ThrownPebble extends StatefulWidget {
  final Offset from;
  final Offset to;
  final VoidCallback onLanded;
  const ThrownPebble({required this.from, required this.to, required this.onLanded, super.key});

  @override
  State<ThrownPebble> createState() => _ThrownPebbleState();
}

class _ThrownPebbleState extends State<ThrownPebble> with SingleTickerProviderStateMixin {
  late final _flightController = AnimationController(vsync: this, duration: _flightDuration);

  @override
  void initState() {
    super.initState();
    _flightController.forward().whenComplete(() {
      if (mounted) widget.onLanded();
    });
  }

  @override
  void dispose() {
    _flightController.dispose();
    super.dispose();
  }

  Offset _positionAt(double progress) {
    final arcHeight = (widget.to - widget.from).distance * _arcHeightToDistance;
    final lift = 4 * progress * (1 - progress) * arcHeight;
    return Offset.lerp(widget.from, widget.to, progress)! - Offset(0, lift);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _flightController,
      child: const DecoratedBox(
        decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.ink),
        child: SizedBox.square(dimension: _pebbleDiameter),
      ),
      builder: (context, pebble) {
        final position = _positionAt(min(_flightController.value, 1));

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: position.dx - _pebbleDiameter / 2,
              top: position.dy - _pebbleDiameter / 2,
              child: pebble!,
            ),
          ],
        );
      },
    );
  }
}
