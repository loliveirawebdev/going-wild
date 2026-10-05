import 'package:going_wild/domain/models/board/board_side.dart';

class BoardRow {
  const BoardRow({required this.side, required this.cellCount, this.blockedColumns = const {}});

  final int cellCount;
  final BoardSide side;
  final Set<int> blockedColumns;

  bool hasCellAt(int column) => column >= 0 && column < cellCount && !blockedColumns.contains(column);
}
