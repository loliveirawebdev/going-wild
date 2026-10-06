import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/board/board.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/ui/game/widgets/board_scene/board_scene_layout.dart';
import 'package:going_wild/ui/game/widgets/summon/roster_summons.dart';
import 'package:going_wild/ui/game/widgets/summon/summon_poof.dart';

const _poofToCellWidth = 1.3;

class FieldSummonPoofs extends StatelessWidget {
  const FieldSummonPoofs({
    required this.board,
    required this.scale,
    required this.summonIds,
    required this.onSummonFinished,
    super.key,
  });

  final Board board;
  final double scale;
  final Map<Position, int> summonIds;
  final SummonFinished<Position> onSummonFinished;

  @override
  Widget build(BuildContext context) {
    final poofSize = BoardSceneLayout.cellSize.width * scale * _poofToCellWidth;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        for (final MapEntry(key: position, value: summonId) in summonIds.entries)
          Positioned.fromRect(
            key: ValueKey(summonId),
            rect: Rect.fromCenter(
              width: poofSize,
              height: poofSize,
              center: BoardSceneLayout.cellRectOf(board, position, scale: scale).center,
            ),
            child: SummonPoof(size: poofSize, onDone: () => onSummonFinished(position, summonId)),
          ),
      ],
    );
  }
}
