import 'package:going_wild/domain/models/board/errors/no_placement_at_position_error.dart';
import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/board/placement_list.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';

RejectedPlayerActionError? checkMovingFromBoardToInventory(MatchProgress matchProgress, {required Position position}) {
  if (matchProgress.checkPreparingActions() case final rejection?) return rejection;
  if (matchProgress.playerRoster.placements.placementAt(position) == null) return NoPlacementAtPositionError(position: position);
  return null;
}

MatchProgress moveFromBoardToInventory(MatchProgress matchProgress, {required Position position, required int inventoryIndex}) {
  if (checkMovingFromBoardToInventory(matchProgress, position: position) case final rejection?) throw rejection;
  final roster = matchProgress.playerRoster;

  final movingPlacement = roster.placements.placementAt(position)!;
  final displacedCharacterCopy = roster.inventory.entryAt(inventoryIndex);

  final inventoryAfterMove = roster.inventory.createCopyWithEntryAt(inventoryIndex, movingPlacement.characterCopy);
  final placementsAfterMove = _placementsAfterLeavingPosition(roster.placements, position, displacedCharacterCopy);

  final rosterAfterMove = roster.createCopyWith(inventory: inventoryAfterMove, placements: placementsAfterMove);
  return matchProgress.createCopyWith(playerRoster: rosterAfterMove);
}

List<Placement> _placementsAfterLeavingPosition(List<Placement> placements, Position position, CharacterCopy? displacedCharacterCopy) {
  if (displacedCharacterCopy == null) return placements.createCopyWithoutPlacementAt(position);
  return placements.createCopyWithPlacement(Placement(position: position, characterCopy: displacedCharacterCopy));
}
