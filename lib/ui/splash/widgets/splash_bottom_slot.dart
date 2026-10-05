import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';

class SplashBottomSlot extends StatelessWidget {
  const SplashBottomSlot({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final safeAreaBottom = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.space6, 0, AppSpacing.space6, safeAreaBottom + AppSpacing.space6),
      child: Center(child: child),
    );
  }
}
