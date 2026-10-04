import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';

class MatchIsOverError extends RejectedPlayerActionError {
  MatchIsOverError() : super('The match is over and accepts no more actions');
}
