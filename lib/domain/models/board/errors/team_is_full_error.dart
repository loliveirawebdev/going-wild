import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';

class TeamIsFullError extends RejectedPlayerActionError {
  TeamIsFullError({required int limit}) : super('The team already has $limit characters on the board');
}
