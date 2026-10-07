import 'package:going_wild/domain/models/board/errors/position_outside_team_side_error.dart';
import 'package:going_wild/domain/models/board/errors/position_taken_by_enemy_error.dart';
import 'package:going_wild/domain/models/board/errors/team_is_full_error.dart';
import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/board/placement_list.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/inventory/errors/empty_inventory_slot_error.dart';
import 'package:going_wild/domain/models/inventory/inventory.dart';
import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';

RejectedPlayerActionError? checkMovingFromInventoryToBoard(
  MatchProgress matchProgress, {
  required Position position,
  required int inventoryIndex,
}) {
  if (matchProgress.checkPreparingActions() case final rejection?) return rejection;
  final roster = matchProgress.playerRoster;
  final board = matchProgress.phase.engines.combatEngine.board;
  if (!board.isPositionOnTeamSide(position)) return PositionOutsideTeamSideError(position: position);
  if (matchProgress.currentWave.enemies.placementAt(position) != null) return PositionTakenByEnemyError(position: position);
  if (roster.inventory.entryAt(inventoryIndex) == null) return EmptyInventorySlotError(index: inventoryIndex);

  final occupiesNewPosition = roster.placements.placementAt(position) == null;
  if (occupiesNewPosition && matchProgress.isTeamFull) return TeamIsFullError(limit: matchProgress.teamLimit);

  return null;
}

MatchProgress moveFromInventoryToBoard(MatchProgress matchProgress, {required Position position, required int inventoryIndex}) {
  if (checkMovingFromInventoryToBoard(matchProgress, position: position, inventoryIndex: inventoryIndex) case final rejection?) {
    throw rejection;
  }

  final roster = matchProgress.playerRoster;

  final movingCharacterCopy = roster.inventory.entryAt(inventoryIndex)!;
  final displacedPlacement = roster.placements.placementAt(position);

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
