import 'package:going_wild/domain/models/board/board.dart';
import 'package:going_wild/domain/models/board/board_row.dart';
import 'package:going_wild/domain/models/board/board_side.dart';

const Board board = Board(
  rows: [
    BoardRow(side: BoardSide.enemy, cellCount: 4),
    BoardRow(side: BoardSide.enemy, cellCount: 5, blockedColumns: {0}),
    BoardRow(side: BoardSide.enemy, cellCount: 4),
    BoardRow(side: BoardSide.shared, cellCount: 5),
    BoardRow(side: BoardSide.team, cellCount: 4),
    BoardRow(side: BoardSide.team, cellCount: 5),
    BoardRow(side: BoardSide.team, cellCount: 4),
  ],
);
