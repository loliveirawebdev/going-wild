import '../../models/board/errors/position_outside_team_half_error.dart';
import '../../models/board/errors/team_is_full_error.dart';
import '../../models/board/placement.dart';
import '../../models/board/placement_list.dart';
import '../../models/board/position.dart';
import '../../models/character/character_copy.dart';
import '../../models/inventory/errors/empty_inventory_slot_error.dart';
import '../../models/inventory/inventory.dart';
import '../../models/match_progress/match_progress.dart';

class MoveFromInventoryToBoard {
  const MoveFromInventoryToBoard();

  MatchProgress call(MatchProgress matchProgress, {required Position position, required int inventoryIndex}) {
    matchProgress.requireInProgress();
    final roster = matchProgress.playerRoster;
    final board = matchProgress.phase.engines.combatEngine.board;
    if (!board.isPositionOnTeamHalf(position)) throw PositionOutsideTeamHalfError(position: position);

    final movingCharacterCopy = roster.inventory.entryAt(inventoryIndex);
    if (movingCharacterCopy == null) throw EmptyInventorySlotError(index: inventoryIndex);

    final teamLimit = matchProgress.playerLevelProgress.level.teamSize;
    final displacedPlacement = roster.placements.placementAt(position);
    final isTeamFull = roster.placements.length >= teamLimit;
    final occupiesNewPosition = displacedPlacement == null;
    if (occupiesNewPosition && isTeamFull) throw TeamIsFullError(limit: teamLimit);

    final movingPlacement = Placement(position: position, characterCopy: movingCharacterCopy);
    final placementsAfterMove = roster.placements.createCopyWithPlacement(movingPlacement);
    final inventoryAfterMove = _inventoryAfterLeavingSlot(roster.inventory, inventoryIndex, displacedPlacement);

    final rosterAfterMove = roster.createCopyWith(inventory: inventoryAfterMove, placements: placementsAfterMove);

    return matchProgress.createCopyWith(playerRoster: rosterAfterMove);
  }

  Inventory<CharacterCopy> _inventoryAfterLeavingSlot(
    Inventory<CharacterCopy> inventory,
    int inventoryIndex,
    Placement? displacedPlacement,
  ) {
    if (displacedPlacement == null) return inventory.createCopyWithoutEntryAt(inventoryIndex);
    return inventory.createCopyWithEntryAt(inventoryIndex, displacedPlacement.characterCopy);
  }
}
