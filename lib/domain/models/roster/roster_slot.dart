import 'package:going_wild/domain/models/board/position.dart';

sealed class RosterSlot {
  const RosterSlot();
}

class InventorySlot extends RosterSlot {
  const InventorySlot({required this.index});
  final int index;

  @override
  String toString() => 'inventory $index';
}

class BoardSlot extends RosterSlot {
  const BoardSlot({required this.position});
  final Position position;

  @override
  String toString() => 'board $position';
}
