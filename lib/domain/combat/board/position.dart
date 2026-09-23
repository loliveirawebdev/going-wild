import 'dart:math';

class Position {
  const Position({required this.row, required this.column});

  final int row;
  final int column;

  int distanceToPosition(Position other) => max((row - other.row).abs(), (column - other.column).abs());
  Position copyMovedBy({int rows = 0, int columns = 0}) => Position(row: row + rows, column: column + columns);

  @override
  bool operator ==(Object other) => other is Position && other.row == row && other.column == column;

  @override
  int get hashCode => Object.hash(row, column);

  @override
  String toString() => '($row, $column)';
}
