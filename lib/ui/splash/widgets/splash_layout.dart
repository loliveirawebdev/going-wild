import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';

const _topBarContentHeight = 52.0;

class SplashLayout extends StatelessWidget {
  const SplashLayout({required this.bottom, super.key, this.topTrailing});

  final Widget bottom;
  final Widget? topTrailing;

  @override
  Widget build(BuildContext context) {
    final safeAreaPadding = MediaQuery.paddingOf(context);
    final topTrailing = this.topTrailing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          alignment: Alignment.topRight,
          height: safeAreaPadding.top + AppSpacing.space3 + _topBarContentHeight,
          padding: EdgeInsets.only(right: AppSpacing.space4, top: safeAreaPadding.top + AppSpacing.space3),
          child: topTrailing,
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.fromLTRB(AppSpacing.space6, 0, AppSpacing.space6, safeAreaPadding.bottom + AppSpacing.space6),
          child: Center(child: bottom),
        ),
      ],
    );
  }
}
