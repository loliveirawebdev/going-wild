import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';

class InventoryIsFullError extends RejectedPlayerActionError {
  InventoryIsFullError() : super('The inventory has no free slot');
}
