import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/match_progress/round_stage.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/view_models/preparation/states/preparation_state.dart';
import 'package:going_wild/ui/game/view_models/roster_drag/roster_drag.dart';
import 'package:going_wild/ui/game/view_models/roster_drag/roster_drag_view_model.dart';
import 'package:going_wild/ui/game/widgets/bench/bench_shelf.dart';
import 'package:going_wild/ui/game/widgets/match_shelves/fight_shelf.dart';
import 'package:going_wild/ui/game/widgets/match_shelves/match_info_shelf.dart';

const _shelfSpacing = AppSpacing.space1;

class MatchBottom extends StatefulWidget {
  const MatchBottom({super.key});

  @override
  State<MatchBottom> createState() => _MatchBottomState();
}

class _MatchBottomState extends State<MatchBottom> {
  var _isBenchExpanded = false;
  bool? _isDraggedCopyOverBench;
  final _benchAreaKey = GlobalKey();

  void _followDrag(RosterDrag? drag) {
    final globalPosition = drag?.globalPosition;
    if (drag == null) _isDraggedCopyOverBench = null;
    if (globalPosition == null) return;

    final benchArea = _benchAreaKey.currentContext?.findRenderObject() as RenderBox?;
    if (benchArea == null) return;

    final benchRect = benchArea.localToGlobal(Offset.zero) & benchArea.size;
    final wasOverBench = _isDraggedCopyOverBench;
    final isOverBench = benchRect.contains(globalPosition);
    _isDraggedCopyOverBench = isOverBench;

    if (wasOverBench == null || wasOverBench == isOverBench) return;
    _changeBenchExpansion(isOverBench);
  }

  void _closeBenchOnTapOutside() {
    final isMatchInFront = ModalRoute.of(context)?.isCurrent ?? true;
    if (isMatchInFront) _changeBenchExpansion(false);
  }

  void _changeBenchExpansion(bool isExpanded) {
    if (isExpanded == _isBenchExpanded) return;
    setState(() => _isBenchExpanded = isExpanded);
  }

  bool _hasFightStarted(PreparationState previous, PreparationState current) =>
      current is ReadyPreparationState && current.matchProgress.roundStage == RoundStage.fighting;

  @override
  Widget build(BuildContext context) {
    final safeAreaBottom = MediaQuery.paddingOf(context).bottom;

    return MultiBlocListener(
      listeners: [
        BlocListener<PreparationBloc, PreparationState>(
          listenWhen: _hasFightStarted,
          listener: (context, state) => _changeBenchExpansion(false),
        ),
        BlocListener<RosterDragViewModel, RosterDrag?>(listener: (context, drag) => _followDrag(drag)),
      ],
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.fromLTRB(AppSpacing.space3, 0, AppSpacing.space3, safeAreaBottom + AppSpacing.space3),
          child: Column(
            spacing: _shelfSpacing,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TapRegion(
                onTapOutside: (event) => _closeBenchOnTapOutside(),
                child: BenchShelf(
                  key: _benchAreaKey,
                  isExpanded: _isBenchExpanded,
                  onExpandedChanged: _changeBenchExpansion,
                ),
              ),

              const MatchInfoShelf(),
              const FightShelf(),
            ],
          ),
        ),
      ),
    );
  }
}
