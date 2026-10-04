import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';

class EmptyShopOfferError extends RejectedPlayerActionError {
  EmptyShopOfferError({required int offerIndex}) : super('Shop offer $offerIndex is empty');
}
