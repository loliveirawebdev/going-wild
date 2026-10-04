import 'package:going_wild/domain/models/board/position.dart';

class PositionNotFreeError extends StateError {
  PositionNotFreeError({required int combatantId, required Position position})
    : super('Combatant $combatantId cannot move to $position because it is outside the board or occupied');
}
