import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';

class PositionOutsideTeamHalfError extends RejectedPlayerActionError {
  PositionOutsideTeamHalfError({required Position position}) : super('Position $position is outside the team half of the board');
}
