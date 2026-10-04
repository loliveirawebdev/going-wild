import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';

class ShopAlreadyLockedError extends RejectedPlayerActionError {
  ShopAlreadyLockedError() : super('The shop is already locked');
}
