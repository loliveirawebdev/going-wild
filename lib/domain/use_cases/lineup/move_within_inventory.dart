import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/inventory/errors/empty_inventory_slot_error.dart';
import 'package:going_wild/domain/models/inventory/inventory.dart';
import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';

RejectedPlayerActionError? checkMovingWithinInventory(MatchProgress matchProgress, {required int fromIndex}) {
  if (matchProgress.checkPreparingActions() case final rejection?) return rejection;
  if (matchProgress.playerRoster.inventory.entryAt(fromIndex) == null) return EmptyInventorySlotError(index: fromIndex);

  return null;
}

MatchProgress moveWithinInventory(MatchProgress matchProgress, {required int toIndex, required int fromIndex}) {
  if (checkMovingWithinInventory(matchProgress, fromIndex: fromIndex) case final rejection?) throw rejection;
  if (fromIndex == toIndex) return matchProgress;
  final roster = matchProgress.playerRoster;

  final inventory = roster.inventory;
  final movingCharacter = inventory.entryAt(fromIndex)!;
  final displacedCharacter = inventory.entryAt(toIndex);

  final inventoryAfterLeaving = _inventoryAfterLeavingSlot(inventory, fromIndex, displacedCharacter);
  final inventoryAfterMove = inventoryAfterLeaving.createCopyWithEntryAt(toIndex, movingCharacter);

  final rosterAfterMove = roster.createCopyWith(inventory: inventoryAfterMove);

  return matchProgress.createCopyWith(playerRoster: rosterAfterMove);
}

Inventory<CharacterCopy> _inventoryAfterLeavingSlot(
  Inventory<CharacterCopy> inventory,
  int leftIndex,
  CharacterCopy? displacedCharacter,
) {
  if (displacedCharacter == null) return inventory.createCopyWithoutEntryAt(leftIndex);
  return inventory.createCopyWithEntryAt(leftIndex, displacedCharacter);
}
