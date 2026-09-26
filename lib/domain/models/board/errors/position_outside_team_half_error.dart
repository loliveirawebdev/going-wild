import '../position.dart';

class PositionOutsideTeamHalfError extends StateError {
  PositionOutsideTeamHalfError({required Position position}) : super('Position $position is outside the team half of the board');
}
