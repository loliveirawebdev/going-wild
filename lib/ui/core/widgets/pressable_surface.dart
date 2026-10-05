import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_shadows.dart';
import 'package:going_wild/ui/core/widgets/pressable.dart';

class PressableSurface extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onPressed: onPressed,
      semanticLabel: semanticLabel,
      disabledReason: disabledReason,
      builder: (context, pressedAmount, child) => Padding(
        padding: const EdgeInsets.only(bottom: AppShadows.pressOffset),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          transform: Matrix4.translationValues(0, AppShadows.pressOffset * pressedAmount, 0),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: borderRadius,
            border: Border.all(color: edgeColor, width: AppBorderWidth.thick),
            boxShadow: [BoxShadow(color: edgeColor, offset: Offset(0, AppShadows.pressOffset * (1 - pressedAmount)))],
          ),
          child: child,
        ),
      ),
      child: child,
    );
  }
}
