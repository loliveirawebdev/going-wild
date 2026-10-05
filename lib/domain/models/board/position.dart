import 'dart:math';

const _axialDirections = [(1, 0), (-1, 0), (0, 1), (0, -1), (1, -1), (-1, 1)];

class Position {
  const Position({
    required this.row,
    required this.column,
  });

  factory Position._fromAxial(int axialColumn, int axialRow) => Position(row: axialRow, column: axialColumn + _halfShiftOfRow(axialRow));

  final int row;
  final int column;

  double get centerY => 1.5 * row;
  int get _axialColumn => column - _halfShiftOfRow(row);
  double get centerX => sqrt(3) * (_axialColumn + row / 2);

  Iterable<Position> get adjacentPositions =>
      _axialDirections.map((direction) => Position._fromAxial(_axialColumn + direction.$1, row + direction.$2));

  bool isWithinRange(Position other, double range) => distanceToPosition(other) <= range;

  int distanceToPosition(Position other) {
    final axialColumnDifference = _axialColumn - other._axialColumn;
    final rowDifference = row - other.row;

    return (axialColumnDifference.abs() + rowDifference.abs() + (axialColumnDifference + rowDifference).abs()) ~/ 2;
  }

  double straightLineDistanceToPosition(Position other) {
    final horizontalDistance = centerX - other.centerX;
    final verticalDistance = centerY - other.centerY;

    return sqrt(horizontalDistance * horizontalDistance + verticalDistance * verticalDistance);
  }

  Position positionAwayFrom(Position origin, {required int steps}) {
    final distance = distanceToPosition(origin);
    if (distance == 0) return this;

    final stepFraction = steps / distance;
    final axialColumn = _axialColumn + (_axialColumn - origin._axialColumn) * stepFraction + 1e-6;
    final axialRow = row + (row - origin.row) * stepFraction + 2e-6;

    return _roundedAxialPosition(axialColumn, axialRow);
  }

  @override
  bool operator ==(Object other) => other is Position && other.row == row && other.column == column;

  @override
  int get hashCode => Object.hash(row, column);

  @override
  String toString() => '($row, $column)';
}

int _halfShiftOfRow(int row) => (row + (row.isOdd ? 1 : 0)) ~/ 2;

Position _roundedAxialPosition(double axialColumn, double axialRow) {
  final cubeThird = -axialColumn - axialRow;
  final roundedThird = cubeThird.round();

  var roundedRow = axialRow.round();
  var roundedColumn = axialColumn.round();

  final rowError = (roundedRow - axialRow).abs();
  final thirdError = (roundedThird - cubeThird).abs();
  final columnError = (roundedColumn - axialColumn).abs();

  if (columnError > rowError && columnError > thirdError) {
    roundedColumn = -roundedRow - roundedThird;
  } else if (rowError > thirdError) {
    roundedRow = -roundedColumn - roundedThird;
  }

  return Position._fromAxial(roundedColumn, roundedRow);
}
