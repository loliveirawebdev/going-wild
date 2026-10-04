import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';

class ShopAlreadyUnlockedError extends RejectedPlayerActionError {
  ShopAlreadyUnlockedError() : super('The shop is already unlocked');
}
