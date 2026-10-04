import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';

class MaxLevelReachedError extends RejectedPlayerActionError {
  MaxLevelReachedError({required int maxLevel}) : super('Level $maxLevel is the max level and has no next level');
}
