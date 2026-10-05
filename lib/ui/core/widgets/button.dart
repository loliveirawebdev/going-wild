import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_shadows.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/widgets/reason_bubble.dart';

const _releaseDuration = Duration(milliseconds: 90);
const _reasonDuration = Duration(milliseconds: 1800);
const _pressDownDuration = Duration(milliseconds: 40);

const _sixtyPercentAlphaRow = <double>[0, 0, 0, 0.6, 0];
const _luminanceRow = <double>[0.2126, 0.7152, 0.0722, 0, 0];
const _grayscaleAtSixtyPercent = ColorFilter.matrix([..._luminanceRow, ..._luminanceRow, ..._luminanceRow, ..._sixtyPercentAlphaRow]);

enum ButtonVariant {
  reward(background: AppColors.sun400, foreground: AppColors.ink, shadows: AppShadows.pressSun),
  primary(background: AppColors.grass400, foreground: AppColors.ink, shadows: AppShadows.pressGrass),
  danger(background: AppColors.barn600, foreground: AppColors.onPrimary, shadows: AppShadows.pressBarn),
  secondary(background: AppColors.surface100, foreground: AppColors.ink, shadows: AppShadows.pressNeutral);

  final Color background;
  final Color foreground;
  final List<BoxShadow> shadows;
  const ButtonVariant({required this.background, required this.foreground, required this.shadows});

  Color get border => shadows.first.color;
}

enum ButtonSize {
  small(fontSize: 15, lineHeight: 18, padding: EdgeInsets.symmetric(vertical: 6, horizontal: AppSpacing.space3)),
  large(fontSize: 22, lineHeight: 26, padding: EdgeInsets.symmetric(vertical: 14, horizontal: AppSpacing.space6)),
  medium(fontSize: 18, lineHeight: 22, padding: EdgeInsets.symmetric(vertical: 10, horizontal: AppSpacing.space4));

  final double fontSize;
  final double lineHeight;
  final EdgeInsets padding;
  const ButtonSize({required this.fontSize, required this.lineHeight, required this.padding});
}

class Button extends StatefulWidget {
  const Button({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.disabledReason,
    this.fillsWidth = false,
    this.size = ButtonSize.medium,
    this.variant = ButtonVariant.primary,
  });

  final String label;
  final Widget? icon;
  final bool fillsWidth;
  final ButtonSize size;
  final ButtonVariant variant;
  final String? disabledReason;
  final VoidCallback? onPressed;

  bool get isEnabled => onPressed != null;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> with SingleTickerProviderStateMixin {
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
    final button = _buildButton();

    if (widget.isEnabled || disabledReason == null) return button;
    return ReasonBubble(reason: disabledReason, controller: _reasonBubbleController, child: button);
  }

  Widget _buildButton() {
    final size = widget.size;
    final variant = widget.variant;
    final isEnabled = widget.isEnabled;
    final icon = widget.icon;
    final edgeColor = isEnabled ? variant.border : AppColors.disabledShadow;
    final foreground = isEnabled ? variant.foreground : AppColors.onDisabled;

    final labelStyle = TextStyle(
      color: foreground,
      letterSpacing: 0.3,
      fontSize: size.fontSize,
      fontFamily: AppFonts.display,
      fontWeight: FontWeight.w400,
      height: size.lineHeight / size.fontSize,
    );

    final content = DefaultTextStyle(
      style: labelStyle,
      child: Row(
        spacing: AppSpacing.space2,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: widget.fillsWidth ? MainAxisSize.max : MainAxisSize.min,
        children: [
          if (icon != null)
            SizedBox.square(
              dimension: size.fontSize,
              child: isEnabled ? icon : ColorFiltered(colorFilter: _grayscaleAtSixtyPercent, child: icon),
            ),
          Text(widget.label),
        ],
      ),
    );

    return Semantics(
      button: true,
      enabled: isEnabled,
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
              child: content,
              builder: (context, content) {
                final pressedAmount = _pressAnimation.value;

                return Container(
                  padding: size.padding,
                  transform: Matrix4.translationValues(0, AppShadows.pressOffset * pressedAmount, 0),
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.medium,
                    color: isEnabled ? variant.background : AppColors.disabled,
                    border: Border.all(color: edgeColor, width: AppBorderWidth.thick),
                    boxShadow: [BoxShadow(color: edgeColor, offset: Offset(0, AppShadows.pressOffset * (1 - pressedAmount)))],
                  ),
                  child: content,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
