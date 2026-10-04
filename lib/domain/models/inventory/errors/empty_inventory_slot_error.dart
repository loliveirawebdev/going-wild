import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';

class EmptyInventorySlotError extends RejectedPlayerActionError {
  EmptyInventorySlotError({required int index}) : super('Inventory slot $index is empty');
}
