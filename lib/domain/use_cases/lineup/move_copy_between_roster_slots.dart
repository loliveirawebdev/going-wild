import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';
import 'package:going_wild/domain/use_cases/lineup/move_from_board_to_inventory.dart';
import 'package:going_wild/domain/use_cases/lineup/move_from_inventory_to_board.dart';
import 'package:going_wild/domain/use_cases/lineup/move_within_board.dart';
import 'package:going_wild/domain/use_cases/lineup/move_within_inventory.dart';

RejectedPlayerActionError? checkMovingCopyBetweenRosterSlots(
  MatchProgress matchProgress, {
  required RosterSlot to,
  required RosterSlot from,
}) => switch ((from, to)) {
  (final InventorySlot from, final BoardSlot to) => checkMovingFromInventoryToBoard(
    matchProgress,
    position: to.position,
    inventoryIndex: from.index,
  ),

  (final BoardSlot from, InventorySlot()) => checkMovingFromBoardToInventory(
    matchProgress,
    position: from.position,
  ),

  (final InventorySlot from, InventorySlot()) => checkMovingWithinInventory(
    matchProgress,
    fromIndex: from.index,
  ),

  (final BoardSlot from, final BoardSlot to) => checkMovingWithinBoard(
    matchProgress,
    toPosition: to.position,
    fromPosition: from.position,
  ),
};

MatchProgress moveCopyBetweenRosterSlots(MatchProgress matchProgress, {required RosterSlot to, required RosterSlot from}) =>
    switch ((from, to)) {
      (final InventorySlot from, final BoardSlot to) => moveFromInventoryToBoard(
        matchProgress,
        position: to.position,
        inventoryIndex: from.index,
      ),

      (final BoardSlot from, final InventorySlot to) => moveFromBoardToInventory(
        matchProgress,
        position: from.position,
        inventoryIndex: to.index,
      ),

      (final InventorySlot from, final InventorySlot to) => moveWithinInventory(
        matchProgress,
        toIndex: to.index,
        fromIndex: from.index,
      ),

      (final BoardSlot from, final BoardSlot to) => moveWithinBoard(
        matchProgress,
        toPosition: to.position,
        fromPosition: from.position,
      ),
    };
