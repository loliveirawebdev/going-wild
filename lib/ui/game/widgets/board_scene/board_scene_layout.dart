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
  static const imageSize = Size(768, 1376);
  static const cellSize = Size(116, 90);

  static const rowCenterHeights = <double>[380, 462, 545, 625, 705, 788, 870];

  static const rowCenterWidths = <List<double>>[
    [170, 305, 440, 575],
    [242, 374, 505, 640],
    [180, 315, 448, 578],
    [120, 255, 385, 515, 640],
    [185, 315, 448, 578],
    [120, 250, 385, 515, 650],
    [180, 315, 450, 580],
  ];

  static double scaleFor(double displayedWidth) => displayedWidth / imageSize.width;

  static Rect cellRectOf(Board board, Position position, {required double scale}) {
    final cellIndexInRow = board.allPositions.where((cell) => cell.row == position.row).toList().indexOf(position);
    final center = Offset(rowCenterWidths[position.row][cellIndexInRow], rowCenterHeights[position.row]);
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
