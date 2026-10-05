import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';

class PositionOutsideTeamSideError extends RejectedPlayerActionError {
  PositionOutsideTeamSideError({required Position position}) : super('Position $position is outside the team side of the board');
}
