import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_shadows.dart';
import 'package:going_wild/ui/core/widgets/reason_bubble.dart';

const _releaseDuration = Duration(milliseconds: 90);
const _reasonDuration = Duration(milliseconds: 1800);
const _pressDownDuration = Duration(milliseconds: 40);

class PressableSurface extends StatefulWidget {
  const PressableSurface({
    required this.child,
    required this.onPressed,
    required this.edgeColor,
    required this.fillColor,
    required this.borderRadius,
    super.key,
    this.width,
    this.height,
    this.semanticLabel,
    this.disabledReason,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final double? width;
  final double? height;
  final Color edgeColor;
  final Color fillColor;
  final EdgeInsets padding;
  final String? semanticLabel;
  final String? disabledReason;
  final VoidCallback? onPressed;
  final BorderRadius borderRadius;

  bool get isEnabled => onPressed != null;

  @override
  State<PressableSurface> createState() => _PressableSurfaceState();
}

class _PressableSurfaceState extends State<PressableSurface> with SingleTickerProviderStateMixin {
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
    final surface = _buildSurface();

    if (widget.isEnabled || disabledReason == null) return surface;
    return ReasonBubble(reason: disabledReason, controller: _reasonBubbleController, child: surface);
  }

  Widget _buildSurface() {
    return Semantics(
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
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppShadows.pressOffset),
            child: AnimatedBuilder(
              animation: _pressAnimation,
              builder: (context, child) {
                final pressedAmount = _pressAnimation.value;
                final elevation = AppShadows.pressOffset * (1 - pressedAmount);

                return Container(
                  width: widget.width,
                  height: widget.height,
                  padding: widget.padding,
                  transform: Matrix4.translationValues(0, AppShadows.pressOffset * pressedAmount, 0),
                  decoration: BoxDecoration(
                    color: widget.fillColor,
                    borderRadius: widget.borderRadius,
                    boxShadow: [BoxShadow(color: widget.edgeColor, offset: Offset(0, elevation))],
                    border: Border.all(color: widget.edgeColor, width: AppBorderWidth.thick),
                  ),
                  child: child,
                );
              },
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
