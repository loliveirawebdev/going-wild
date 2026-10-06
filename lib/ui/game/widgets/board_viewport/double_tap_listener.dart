import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

class DoubleTapListener extends StatefulWidget {
  final Widget child;
  final VoidCallback onDoubleTap;
  const DoubleTapListener({required this.child, required this.onDoubleTap, super.key});

  @override
  State<DoubleTapListener> createState() => _DoubleTapListenerState();
}

class _DoubleTapListenerState extends State<DoubleTapListener> {
  final _downPositions = <int, Offset>{};
  var _isTapCandidate = false;
  ({Duration timeStamp, Offset position})? _lastTap;

  void _onPointerDown(PointerDownEvent event) {
    _downPositions[event.pointer] = event.position;
    _isTapCandidate = _downPositions.length == 1;
  }

  void _onPointerMove(PointerMoveEvent event) {
    final downPosition = _downPositions[event.pointer];
    if (downPosition != null && (event.position - downPosition).distance > kTouchSlop) _isTapCandidate = false;
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _downPositions.remove(event.pointer);
    _isTapCandidate = false;
    _lastTap = null;
  }

  void _onPointerUp(PointerUpEvent event) {
    _downPositions.remove(event.pointer);
    if (!_isTapCandidate) {
      _lastTap = null;
      return;
    }

    final lastTap = _lastTap;
    final isDoubleTap =
        lastTap != null &&
        event.timeStamp - lastTap.timeStamp <= kDoubleTapTimeout &&
        (event.position - lastTap.position).distance <= kDoubleTapSlop;

    _isTapCandidate = false;
    _lastTap = isDoubleTap ? null : (timeStamp: event.timeStamp, position: event.position);
    if (isDoubleTap) widget.onDoubleTap();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: _onPointerUp,
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerCancel: _onPointerCancel,
      child: widget.child,
    );
  }
}
