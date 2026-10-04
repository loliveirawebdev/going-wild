import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';

class NotEnoughCoinsError extends RejectedPlayerActionError {
  NotEnoughCoinsError({required int costInCoins, required int coins}) : super('Cannot spend $costInCoins coins with only $coins coins');
}
