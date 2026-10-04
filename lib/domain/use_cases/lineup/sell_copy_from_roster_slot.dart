import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';
import 'package:going_wild/domain/use_cases/lineup/sell_from_board.dart';
import 'package:going_wild/domain/use_cases/lineup/sell_from_inventory.dart';

RejectedPlayerActionError? checkSellingCopyFromRosterSlot(MatchProgress matchProgress, {required RosterSlot from}) => switch (from) {
  final InventorySlot from => checkSellingFromInventory(matchProgress, inventoryIndex: from.index),
  final BoardSlot from => checkSellingFromBoard(matchProgress, position: from.position),
};

MatchProgress sellCopyFromRosterSlot(MatchProgress matchProgress, {required RosterSlot from}) => switch (from) {
  final InventorySlot from => sellFromInventory(matchProgress, inventoryIndex: from.index),
  final BoardSlot from => sellFromBoard(matchProgress, position: from.position),
};
