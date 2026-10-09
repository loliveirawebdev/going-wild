import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';

class Pill extends StatelessWidget {
  const Pill({
    required this.child,
    super.key,
    this.leading,
    this.height,
    this.spacing = 4,
    this.borderColor,
    this.padding = EdgeInsets.zero,
    this.color = AppColors.surface100,
    this.borderWidth = AppBorderWidth.thin,
  });

  final Widget child;
  final Color color;
  final double spacing;
  final double? height;
  final Widget? leading;
  final Color? borderColor;
  final double borderWidth;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final leading = this.leading;
    final borderColor = this.borderColor;

    return Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppRadius.pill,
        border: borderColor == null ? null : Border.all(color: borderColor, width: borderWidth),
      ),
      child: leading == null
          ? child
          : Row(
              spacing: spacing,
              mainAxisSize: MainAxisSize.min,
              children: [
                leading,
                Flexible(child: child),
              ],
            ),
    );
  }
}
