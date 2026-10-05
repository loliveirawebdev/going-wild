import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/game/widgets/match_shelves/match_info_shelf.dart';

class MatchBottom extends StatelessWidget {
  const MatchBottom({super.key});

  @override
  Widget build(BuildContext context) {
    final safeAreaBottom = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.space3, 0, AppSpacing.space3, safeAreaBottom + AppSpacing.space3),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [MatchInfoShelf()],
      ),
    );
  }
}
