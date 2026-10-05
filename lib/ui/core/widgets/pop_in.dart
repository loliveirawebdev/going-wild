import 'package:flutter/widgets.dart';

const _popCurve = Cubic(0.2, 1.6, 0.4, 1);

class PopIn extends StatefulWidget {
  final Widget child;
  final Duration duration;
  const PopIn({required this.child, required this.duration, super.key});

  @override
  State<PopIn> createState() => _PopInState();
}

class _PopInState extends State<PopIn> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: widget.duration)..forward();
  late final _scale = Tween<double>(begin: 0.3, end: 1).animate(CurvedAnimation(parent: _controller, curve: _popCurve));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}
