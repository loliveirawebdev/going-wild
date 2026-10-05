import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';

const _pillHeight = 34.0;
const _colorChangeDuration = Duration(milliseconds: 160);

class TopBarPill extends StatelessWidget {
  const TopBarPill({
    required this.child,
    required this.edgeColor,
    required this.fillColor,
    super.key,
    this.horizontalPadding = 10,
  });

  final Widget child;
  final Color edgeColor;
  final Color fillColor;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: _pillHeight,
      alignment: Alignment.center,
      duration: _colorChangeDuration,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: AppRadius.pill,
        border: Border.all(color: edgeColor, width: AppBorderWidth.thick),
      ),
      child: child,
    );
  }
}
