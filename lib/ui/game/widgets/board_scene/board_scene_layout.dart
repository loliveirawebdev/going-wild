import 'dart:ui';

import 'package:going_wild/domain/models/board/board.dart';
import 'package:going_wild/domain/models/board/position.dart';

const _hexagonCornerFractions = [
  Offset(0, 0.5),
  Offset(0.24, 0),
  Offset(0.76, 0),
  Offset(1, 0.5),
  Offset(0.76, 1),
  Offset(0.24, 1),
];

abstract final class BoardSceneLayout {
  static const imageSize = Size(937, 1678);
  static const cellSize = Size(146, 112);

  static const rowCenterHeights = <double>[441, 540, 637, 734, 836, 946, 1053];

  static const rowCenterWidths = <List<double>>[
    [208, 368, 527, 686],
    [296, 452, 610, 766],
    [221, 378, 537, 695],
    [150, 307, 462, 618, 777],
    [226, 383, 542, 701],
    [145, 304, 466, 628, 789],
    [221, 382, 545, 711],
  ];

  static double scaleFor(double displayedWidth) => displayedWidth / imageSize.width;

  static final _cellCentersByBoard = Expando<Map<Position, Offset>>();

  static Map<Position, Offset> _cellCentersOf(Board board) {
    final cachedCellCenters = _cellCentersByBoard[board];
    if (cachedCellCenters != null) return cachedCellCenters;

    final cellCountByRow = <int, int>{};
    final cellCenters = <Position, Offset>{};
    for (final position in board.allPositions) {
      final cellIndexInRow = cellCountByRow[position.row] ?? 0;
      cellCountByRow[position.row] = cellIndexInRow + 1;
      cellCenters[position] = Offset(rowCenterWidths[position.row][cellIndexInRow], rowCenterHeights[position.row]);
    }

    return _cellCentersByBoard[board] = Map.unmodifiable(cellCenters);
  }

  static Rect cellRectOf(Board board, Position position, {required double scale}) {
    final center = _cellCentersOf(board)[position] ?? (throw RangeError('$position is not on the board'));
    return Rect.fromCenter(center: center * scale, width: cellSize.width * scale, height: cellSize.height * scale);
  }

  static Path hexagonPathIn(Rect cellRect) {
    final corners = [
      for (final fraction in _hexagonCornerFractions)
        Offset(cellRect.left + fraction.dx * cellRect.width, cellRect.top + fraction.dy * cellRect.height),
    ];

    return Path()..addPolygon(corners, true);
  }
}
