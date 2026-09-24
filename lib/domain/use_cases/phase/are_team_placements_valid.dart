import '../../models/combat/board/placement.dart';
import '../../models/phase/phase_run.dart';
import '../../models/phase/phase_status.dart';
import '../../models/player/player.dart';

bool areTeamPlacementsValid(PhaseRun phaseRun, List<Placement> teamPlacements) {
  if (phaseRun.status != PhaseStatus.inProgress) return false;
  if (teamPlacements.length > phaseRun.player.level) return false;

  final board = phaseRun.rules.board;
  final hasRepeatedPosition = teamPlacements.map((placement) => placement.position).toSet().length != teamPlacements.length;
  if (hasRepeatedPosition) return false;

  final isEveryPositionInTeamHalf = teamPlacements.every((placement) {
    final isPositionWithinBounds = board.isPositionWithinBounds(placement.position);
    final isPlacementInTopSide = placement.position.row >= board.rows ~/ 2;
    return isPositionWithinBounds && isPlacementInTopSide;
  });

  if (!isEveryPositionInTeamHalf) return false;
  return _isEveryPlacementOwnedByThePlayer(phaseRun.player, teamPlacements);
}

bool _isEveryPlacementOwnedByThePlayer(Player player, List<Placement> teamPlacements) {
  final ownedCharactersNotPlacedYet = [...player.ownedCharacters];

  for (final placement in teamPlacements) {
    final matchingOwnedCharacter = ownedCharactersNotPlacedYet
        .where((ownedCharacter) => ownedCharacter.character == placement.character && ownedCharacter.stars == placement.stars)
        .firstOrNull;

    if (matchingOwnedCharacter == null) return false;
    ownedCharactersNotPlacedYet.remove(matchingOwnedCharacter);
  }

  return true;
}
