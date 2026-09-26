import '../../models/character/character_copy.dart';
import '../../models/inventory/errors/empty_inventory_slot_error.dart';
import '../../models/inventory/inventory.dart';
import '../../models/match_progress/match_progress.dart';

class MoveWithinInventory {
  const MoveWithinInventory();

  MatchProgress call(MatchProgress matchProgress, {required int toIndex, required int fromIndex}) {
    matchProgress.requireInProgress();
    final roster = matchProgress.playerRoster;

    final inventory = roster.inventory;
    final movingCharacter = inventory.entryAt(fromIndex);
    if (movingCharacter == null) throw EmptyInventorySlotError(index: fromIndex);

    final displacedCharacter = inventory.entryAt(toIndex);
    if (fromIndex == toIndex) return matchProgress;

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
}
