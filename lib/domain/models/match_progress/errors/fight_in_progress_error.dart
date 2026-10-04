import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';

class FightInProgressError extends RejectedPlayerActionError {
  FightInProgressError() : super('The fight is in progress and preparing actions wait for the next round');
}
