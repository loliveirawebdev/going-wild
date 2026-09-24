import 'position.dart';

class Board {
  const Board({required this.rows, required this.columns});

  final int rows;
  final int columns;

  bool isPositionWithinBounds(Position position) {
    final rowIsInside = position.row >= 0 && position.row < rows;
    final columnIsInside = position.column >= 0 && position.column < columns;
    return rowIsInside && columnIsInside;
  }

  Iterable<Position> neighborPositionsAround(Position center) sync* {
    for (var rowStep = -1; rowStep <= 1; rowStep++) {
      for (var columnStep = -1; columnStep <= 1; columnStep++) {
        final isTheCenterItself = rowStep == 0 && columnStep == 0;
        if (isTheCenterItself) continue;

        final neighbor = center.copyMovedBy(rows: rowStep, columns: columnStep);
        if (isPositionWithinBounds(neighbor)) yield neighbor;
      }
    }
  }

  Iterable<Position> get allPositions sync* {
    for (var row = 0; row < rows; row++) {
      for (var column = 0; column < columns; column++) {
        yield Position(row: row, column: column);
      }
    }
  }
}
