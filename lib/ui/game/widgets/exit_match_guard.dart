import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:going_wild/ui/game/view_models/match_flow/match_flow_bloc.dart';
import 'package:going_wild/ui/game/view_models/match_flow/states/match_flow_state.dart';
import 'package:going_wild/ui/game/widgets/match_top_bar/exit_match_dialog.dart';

class ExitMatchGuard extends StatelessWidget {
  const ExitMatchGuard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchFlowBloc, MatchFlowState>(
      buildWhen: (previous, current) => (previous is EndedMatchFlowState) != (current is EndedMatchFlowState),
      builder: (context, matchFlowState) => PopScope(
        canPop: matchFlowState is EndedMatchFlowState,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            presentExitMatchDialog(
              context,
              onExit: GoRouter.of(context).pop,
            );
          }
        },
        child: child,
      ),
    );
  }
}
