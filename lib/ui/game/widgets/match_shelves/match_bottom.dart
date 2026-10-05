import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/match_progress/round_stage.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/view_models/preparation/states/preparation_state.dart';
import 'package:going_wild/ui/game/widgets/bench/bench_shelf.dart';
import 'package:going_wild/ui/game/widgets/match_shelves/match_info_shelf.dart';

const _shelfSpacing = AppSpacing.space1;

class MatchBottom extends StatefulWidget {
  const MatchBottom({super.key});

  @override
  State<MatchBottom> createState() => _MatchBottomState();
}

class _MatchBottomState extends State<MatchBottom> {
  var _isBenchExpanded = false;
  var _isDraggedCopyOverBench = true;

  final _benchAreaKey = GlobalKey();

  void _followDraggedCopy(Offset globalPosition) {
    final benchArea = _benchAreaKey.currentContext?.findRenderObject() as RenderBox?;
    if (benchArea == null) return;

    final benchRect = benchArea.localToGlobal(Offset.zero) & benchArea.size;
    final isOverBench = benchRect.contains(globalPosition);
    if (isOverBench == _isDraggedCopyOverBench) return;

    _isDraggedCopyOverBench = isOverBench;
    _changeBenchExpansion(isOverBench);
  }

  void _endDraggingCopy() => _isDraggedCopyOverBench = true;

  void _changeBenchExpansion(bool isExpanded) {
    if (isExpanded == _isBenchExpanded) return;
    setState(() => _isBenchExpanded = isExpanded);
  }

  bool _hasFightStarted(PreparationState previous, PreparationState current) =>
      current is ReadyPreparationState && current.matchProgress.roundStage == RoundStage.fighting;

  @override
  Widget build(BuildContext context) {
    final safeAreaBottom = MediaQuery.paddingOf(context).bottom;

    return BlocListener<PreparationBloc, PreparationState>(
      listenWhen: _hasFightStarted,
      listener: (context, state) => _changeBenchExpansion(false),
      child: Stack(
        children: [
          Positioned.fill(
            child: _isBenchExpanded
                ? GestureDetector(behavior: HitTestBehavior.opaque, onTap: () => _changeBenchExpansion(false))
                : const SizedBox.shrink(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.fromLTRB(AppSpacing.space3, 0, AppSpacing.space3, safeAreaBottom + AppSpacing.space3),
              child: Column(
                spacing: _shelfSpacing,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BenchShelf(
                    key: _benchAreaKey,
                    isExpanded: _isBenchExpanded,
                    onCopyDragEnded: _endDraggingCopy,
                    onCopyDragUpdated: _followDraggedCopy,
                    onExpandedChanged: _changeBenchExpansion,
                  ),
                  const MatchInfoShelf(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
