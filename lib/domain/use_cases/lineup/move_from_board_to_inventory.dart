import '../../models/board/errors/no_placement_at_position_error.dart';
import '../../models/board/placement.dart';
import '../../models/board/placement_list.dart';
import '../../models/board/position.dart';
import '../../models/character/character_copy.dart';
import '../../models/match_progress/match_progress.dart';

class MoveFromBoardToInventory {
  const MoveFromBoardToInventory();

  MatchProgress call(MatchProgress matchProgress, {required Position position, required int inventoryIndex}) {
    matchProgress.requireInProgress();
    final roster = matchProgress.playerRoster;

    final movingPlacement = roster.placements.placementAt(position);
    final displacedCharacterCopy = roster.inventory.entryAt(inventoryIndex);
    if (movingPlacement == null) throw NoPlacementAtPositionError(position: position);

    final inventoryAfterMove = roster.inventory.createCopyWithEntryAt(inventoryIndex, movingPlacement.characterCopy);
    final placementsAfterMove = _placementsAfterLeavingPosition(roster.placements, position, displacedCharacterCopy);

    final rosterAfterMove = roster.createCopyWith(inventory: inventoryAfterMove, placements: placementsAfterMove);

    return matchProgress.createCopyWith(playerRoster: rosterAfterMove);
  }

  List<Placement> _placementsAfterLeavingPosition(List<Placement> placements, Position position, CharacterCopy? displacedCharacterCopy) {
    if (displacedCharacterCopy == null) return placements.createCopyWithoutPlacementAt(position);
    return placements.createCopyWithPlacement(Placement(position: position, characterCopy: displacedCharacterCopy));
  }
}
