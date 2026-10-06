import 'package:flutter/widgets.dart';

const _appearDelay = Duration(milliseconds: 180);
const _appearDuration = Duration(milliseconds: 500);
const _bounceCurve = Cubic(0.2, 1.5, 0.4, 1);

const _keyframes = <({double at, Offset scale})>[
  (at: 0, scale: Offset.zero),
  (at: 0.45, scale: Offset(1.25, 0.8)),
  (at: 0.7, scale: Offset(0.9, 1.12)),
  (at: 1, scale: Offset(1, 1)),
];

class SummonAppear extends StatefulWidget {
  final Widget child;
  final Object? summonId;
  const SummonAppear({required this.child, required this.summonId, super.key});

  @override
  State<SummonAppear> createState() => _SummonAppearState();
}

class _SummonAppearState extends State<SummonAppear> with SingleTickerProviderStateMixin {
  late final _appearController = AnimationController(vsync: this, duration: _appearDelay + _appearDuration, value: 1);

  @override
  void initState() {
    super.initState();
    if (widget.summonId != null) _appearController.forward(from: 0);
  }

  @override
  void didUpdateWidget(SummonAppear oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.summonId != null && widget.summonId != oldWidget.summonId) _appearController.forward(from: 0);
  }

  @override
  void dispose() {
    _appearController.dispose();
    super.dispose();
  }

  Offset _scaleAt(double controllerValue) {
    final totalMs = (_appearDelay + _appearDuration).inMilliseconds;
    final progress = ((controllerValue * totalMs - _appearDelay.inMilliseconds) / _appearDuration.inMilliseconds).clamp(0.0, 1.0);

    for (var index = 1; index < _keyframes.length; index++) {
      final from = _keyframes[index - 1];
      final to = _keyframes[index];
      if (progress > to.at) continue;

      final eased = _bounceCurve.transform((progress - from.at) / (to.at - from.at));
      return Offset.lerp(from.scale, to.scale, eased)!;
    }

    return _keyframes.last.scale;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _appearController,
      child: widget.child,
      builder: (context, child) {
        final scale = _scaleAt(_appearController.value);

        return Transform(
          alignment: Alignment.bottomCenter,
          transform: Matrix4.diagonal3Values(scale.dx, scale.dy, 1),
          child: child,
        );
      },
    );
  }
}
