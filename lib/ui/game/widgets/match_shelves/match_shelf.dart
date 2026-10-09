import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_shadows.dart';

const _shelfPadding = 5.0;
const matchShelfChromeHeight = _shelfPadding * 2 + AppBorderWidth.thick * 2 + AppShadows.pressOffset;

class MatchShelf extends StatelessWidget {
  const MatchShelf({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppShadows.pressOffset),
      child: Container(
        padding: const EdgeInsets.all(_shelfPadding),
        decoration: BoxDecoration(
          color: AppColors.surface200,
          borderRadius: AppRadius.medium,
          boxShadow: AppShadows.pressNeutral,
          border: Border.all(color: AppColors.surface400, width: AppBorderWidth.thick),
        ),
        child: child,
      ),
    );
  }
}
