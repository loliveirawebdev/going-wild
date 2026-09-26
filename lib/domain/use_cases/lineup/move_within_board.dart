import '../../models/board/errors/no_placement_at_position_error.dart';
import '../../models/board/errors/position_outside_team_half_error.dart';
import '../../models/board/placement.dart';
import '../../models/board/placement_list.dart';
import '../../models/board/position.dart';
import '../../models/match_progress/match_progress.dart';

class MoveWithinBoard {
  const MoveWithinBoard();

  MatchProgress call(MatchProgress matchProgress, {required Position toPosition, required Position fromPosition}) {
    matchProgress.requireInProgress();
    final roster = matchProgress.playerRoster;
    final board = matchProgress.phase.engines.combatEngine.board;
    if (!board.isPositionOnTeamHalf(toPosition)) throw PositionOutsideTeamHalfError(position: toPosition);

    final placements = roster.placements;
    final movingPlacement = placements.placementAt(fromPosition);
    if (movingPlacement == null) throw NoPlacementAtPositionError(position: fromPosition);
    if (fromPosition == toPosition) return matchProgress;

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
}
