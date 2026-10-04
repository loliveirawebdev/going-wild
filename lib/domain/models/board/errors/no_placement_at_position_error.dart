import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';

class NoPlacementAtPositionError extends RejectedPlayerActionError {
  NoPlacementAtPositionError({required Position position}) : super('Nobody is placed at $position');
}
