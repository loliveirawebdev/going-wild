import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/widgets/reason_bubble.dart';

const _releaseDuration = Duration(milliseconds: 90);
const _reasonDuration = Duration(milliseconds: 1800);
const _pressDownDuration = Duration(milliseconds: 40);

typedef PressedAmountBuilder = Widget Function(BuildContext context, double pressedAmount, Widget? child);

class Pressable extends StatefulWidget {
  const Pressable({
    required this.builder,
    required this.onPressed,
    super.key,
    this.child,
    this.semanticLabel,
    this.disabledReason,
  });

  final Widget? child;
  final String? semanticLabel;
  final String? disabledReason;
  final VoidCallback? onPressed;
  final PressedAmountBuilder builder;

  bool get isEnabled => onPressed != null;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> with SingleTickerProviderStateMixin {
  var _isPointerDown = false;
  Timer? _reasonTimer;
  final _reasonBubbleController = OverlayPortalController();

  late final _pressController = AnimationController(
    vsync: this,
    duration: _pressDownDuration,
    reverseDuration: _releaseDuration,
  );

  late final _pressAnimation = CurvedAnimation(
    curve: Curves.easeOut,
    parent: _pressController,
    reverseCurve: Curves.easeIn,
  );

  @override
  void dispose() {
    _reasonTimer?.cancel();
    _pressAnimation.dispose();
    _pressController.dispose();
    super.dispose();
  }

  void _press() {
    if (!widget.isEnabled) return;
    _isPointerDown = true;
    _pressController.forward();
  }

  void _release() {
    if (!_isPointerDown) return;
    _isPointerDown = false;

    _pressController.forward().whenComplete(() {
      if (mounted && !_isPointerDown) _pressController.reverse();
    });
  }

  void _onTap() {
    final onPressed = widget.onPressed;
    if (onPressed != null) return onPressed();
    if (widget.disabledReason == null) return;

    _reasonTimer?.cancel();
    _reasonTimer = Timer(_reasonDuration, _reasonBubbleController.hide);
    _reasonBubbleController.show();
  }

  @override
  Widget build(BuildContext context) {
    final disabledReason = widget.disabledReason;

    final pressable = Semantics(
      button: true,
      label: widget.semanticLabel,
      enabled: widget.isEnabled,
      child: Listener(
        onPointerDown: (_) => _press(),
        onPointerUp: (_) => _release(),
        onPointerCancel: (_) => _release(),
        child: GestureDetector(
          onTap: _onTap,
          onTapCancel: _release,
          child: AnimatedBuilder(
            animation: _pressAnimation,
            builder: (context, child) => widget.builder(context, _pressAnimation.value, child),
            child: widget.child,
          ),
        ),
      ),
    );

    if (widget.isEnabled || disabledReason == null) return pressable;
    return ReasonBubble(reason: disabledReason, controller: _reasonBubbleController, child: pressable);
  }
}
