import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/match_progress/round_stage.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/view_models/preparation/states/preparation_state.dart';
import 'package:going_wild/ui/game/view_models/roster_drag/roster_drag.dart';
import 'package:going_wild/ui/game/view_models/roster_drag/roster_drag_view_model.dart';
import 'package:going_wild/ui/game/widgets/bench/bench_shelf.dart';
import 'package:going_wild/ui/game/widgets/board_viewport/match_board_viewport.dart';
import 'package:going_wild/ui/game/widgets/match_shelves/fight_shelf.dart';
import 'package:going_wild/ui/game/widgets/match_shelves/match_info_shelf.dart';

const _shelfSpacing = AppSpacing.space1;
const _sideMargin = AppSpacing.space3;
const _bottomMargin = AppSpacing.space3;

enum _MatchBodySlot { board, bench, info, fight }

class MatchBody extends StatefulWidget {
  const MatchBody({super.key});

  @override
  State<MatchBody> createState() => _MatchBodyState();
}

class _MatchBodyState extends State<MatchBody> {
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
    final bottomInset = MediaQuery.paddingOf(context).bottom + _bottomMargin;

    return MultiBlocListener(
      listeners: [
        BlocListener<PreparationBloc, PreparationState>(
          listenWhen: _hasFightStarted,
          listener: (context, state) => _changeBenchExpansion(false),
        ),
        BlocListener<RosterDragViewModel, RosterDrag?>(listener: (context, drag) => _followDrag(drag)),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) => CustomMultiChildLayout(
          delegate: _MatchBodyLayout(bottomInset: bottomInset),
          children: [
            LayoutId(
              id: _MatchBodySlot.board,
              child: LayoutBuilder(
                builder: (context, boardConstraints) => OverflowBox(
                  alignment: Alignment.topCenter,
                  minHeight: constraints.maxHeight,
                  maxHeight: constraints.maxHeight,
                  child: MatchBoardViewport(fieldBottomLimit: boardConstraints.maxHeight),
                ),
              ),
            ),
            LayoutId(
              id: _MatchBodySlot.bench,
              child: TapRegion(
                onTapOutside: (event) => _closeBenchOnTapOutside(),
                child: BenchShelf(
                  key: _benchAreaKey,
                  isExpanded: _isBenchExpanded,
                  onExpandedChanged: _changeBenchExpansion,
                ),
              ),
            ),
            LayoutId(id: _MatchBodySlot.info, child: const MatchInfoShelf()),
            LayoutId(id: _MatchBodySlot.fight, child: const FightShelf()),
          ],
        ),
      ),
    );
  }
}

class _MatchBodyLayout extends MultiChildLayoutDelegate {
  final double bottomInset;
  _MatchBodyLayout({required this.bottomInset});

  @override
  void performLayout(Size size) {
    final shelfConstraints = BoxConstraints.tightFor(width: max(size.width - _sideMargin * 2, 0));
    final fightSize = layoutChild(_MatchBodySlot.fight, shelfConstraints);
    final infoSize = layoutChild(_MatchBodySlot.info, shelfConstraints);
    final benchSize = layoutChild(_MatchBodySlot.bench, shelfConstraints);

    final fightTop = size.height - bottomInset - fightSize.height;
    final infoTop = fightTop - _shelfSpacing - infoSize.height;
    final benchTop = infoTop - _shelfSpacing - benchSize.height;
    final closedBenchTop = max(infoTop - _shelfSpacing - BenchShelf.closedHeight, 0.0);

    positionChild(_MatchBodySlot.fight, Offset(_sideMargin, fightTop));
    positionChild(_MatchBodySlot.info, Offset(_sideMargin, infoTop));
    positionChild(_MatchBodySlot.bench, Offset(_sideMargin, benchTop));

    layoutChild(_MatchBodySlot.board, BoxConstraints.tightFor(width: size.width, height: closedBenchTop));
    positionChild(_MatchBodySlot.board, Offset.zero);
  }

  @override
  bool shouldRelayout(_MatchBodyLayout oldDelegate) => oldDelegate.bottomInset != bottomInset;
}
