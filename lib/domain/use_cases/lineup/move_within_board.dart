import 'package:going_wild/domain/models/board/errors/no_placement_at_position_error.dart';
import 'package:going_wild/domain/models/board/errors/position_outside_team_half_error.dart';
import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/board/placement_list.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';

RejectedPlayerActionError? checkMovingWithinBoard(
  MatchProgress matchProgress, {
  required Position toPosition,
  required Position fromPosition,
}) {
  if (matchProgress.checkPreparingActions() case final rejection?) return rejection;
  final board = matchProgress.phase.engines.combatEngine.board;
  if (!board.isPositionOnTeamHalf(toPosition)) return PositionOutsideTeamHalfError(position: toPosition);
  if (matchProgress.playerRoster.placements.placementAt(fromPosition) == null) return NoPlacementAtPositionError(position: fromPosition);

  return null;
}

MatchProgress moveWithinBoard(MatchProgress matchProgress, {required Position toPosition, required Position fromPosition}) {
  if (checkMovingWithinBoard(matchProgress, toPosition: toPosition, fromPosition: fromPosition) case final rejection?) {
    throw rejection;
  }

  if (fromPosition == toPosition) return matchProgress;
  final roster = matchProgress.playerRoster;

  final placements = roster.placements;
  final movingPlacement = placements.placementAt(fromPosition)!;
  final displacedPlacement = placements.placementAt(toPosition);
  final placementsAfterLeaving = _placementsAfterLeavingPosition(placements, fromPosition, displacedPlacement);

  final movedPlacement = Placement(position: toPosition, characterCopy: movingPlacement.characterCopy);
  final placementsAfterMove = placementsAfterLeaving.createCopyWithPlacement(movedPlacement);
  final rosterAfterMove = roster.createCopyWith(placements: placementsAfterMove);

  return matchProgress.createCopyWith(playerRoster: rosterAfterMove);
}

List<Placement> _placementsAfterLeavingPosition(List<Placement> placements, Position leftPosition, Placement? displacedPlacement) {
  if (displacedPlacement == null) return placements.createCopyWithoutPlacementAt(leftPosition);

  return placements.createCopyWithPlacement(Placement(position: leftPosition, characterCopy: displacedPlacement.characterCopy));
}
