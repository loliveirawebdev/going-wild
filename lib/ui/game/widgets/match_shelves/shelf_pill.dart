import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';

const _pillHeight = 40.0;

class ShelfPill extends StatelessWidget {
  const ShelfPill({required this.child, required this.padding, super.key});

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      height: _pillHeight,
      decoration: BoxDecoration(
        color: AppColors.surface100,
        borderRadius: AppRadius.pill,
        border: Border.all(color: AppColors.surface400, width: AppBorderWidth.thick),
      ),
      child: child,
    );
  }
}
