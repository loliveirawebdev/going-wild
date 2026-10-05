import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';

class PositionTakenByEnemyError extends RejectedPlayerActionError {
  PositionTakenByEnemyError({required Position position}) : super('Position $position is taken by an enemy of the current wave');
}
