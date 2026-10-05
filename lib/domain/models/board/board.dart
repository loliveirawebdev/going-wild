import 'package:going_wild/domain/models/board/board_row.dart';
import 'package:going_wild/domain/models/board/board_side.dart';
import 'package:going_wild/domain/models/board/position.dart';

class Board {
  const Board({required this.rows});
  final List<BoardRow> rows;

  bool isPositionWithinBounds(Position position) {
    final rowIsInside = position.row >= 0 && position.row < rows.length;
    return rowIsInside && rows[position.row].hasCellAt(position.column);
  }

  int get widestRowCellCount => rows.fold(0, (widest, row) => row.cellCount > widest ? row.cellCount : widest);
  Iterable<Position> neighborPositionsAround(Position center) => center.adjacentPositions.where(isPositionWithinBounds);
  bool isPositionOnTeamSide(Position position) => isPositionWithinBounds(position) && rows[position.row].side != BoardSide.enemy;
  bool isPositionOnEnemySide(Position position) => isPositionWithinBounds(position) && rows[position.row].side != BoardSide.team;

  Iterable<Position> get allPositions sync* {
    for (final (rowIndex, row) in rows.indexed) {
      for (var column = 0; column < row.cellCount; column++) {
        if (row.hasCellAt(column)) yield Position(row: rowIndex, column: column);
      }
    }
  }
}
