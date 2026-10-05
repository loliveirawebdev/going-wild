import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/board/placement_list.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/match_progress/round_stage.dart';
import 'package:going_wild/domain/use_cases/shop/refresh_shop_offers.dart';

MatchProgress startRound(MatchProgress matchProgress) {
  final engines = matchProgress.phase.engines;
  final levelEngine = engines.levelEngine;
  final roundIncome = engines.economyEngine.roundIncome(matchProgress: matchProgress);
  final experienceForRound = levelEngine.experienceForRound(matchProgress: matchProgress);

  final rewardedMatchProgress = matchProgress.createCopyWith(
    roundStage: RoundStage.preparing,
    player: matchProgress.player.createCopyWithCoinsReceived(roundIncome),
    playerLevelProgress: levelEngine.gainExperience(matchProgress.playerLevelProgress, experienceForRound),
    playerRoster: matchProgress.playerRoster.createCopyWith(placements: _placementsClearOfWaveEnemies(matchProgress)),
  );

  if (rewardedMatchProgress.shop.isLocked) return rewardedMatchProgress;
  return refreshShopOffers(rewardedMatchProgress);
}

List<Placement> _placementsClearOfWaveEnemies(MatchProgress matchProgress) {
  final board = matchProgress.phase.engines.combatEngine.board;
  final enemyPositions = matchProgress.currentWave.enemies.map((enemy) => enemy.position).toSet();
  var placements = matchProgress.playerRoster.placements;

  for (final blockedPlacement in placements.where((placement) => enemyPositions.contains(placement.position)).toList()) {
    final takenPositions = {...enemyPositions, ...placements.map((placement) => placement.position)};
    final freeTeamPositions = board.allPositions.where(
      (position) => board.isPositionOnTeamSide(position) && !takenPositions.contains(position),
    );

    final closestFreePosition = _closestPosition(freeTeamPositions, to: blockedPlacement.position);
    if (closestFreePosition == null) continue;

    final movedPlacement = Placement(position: closestFreePosition, characterCopy: blockedPlacement.characterCopy);
    placements = placements.createCopyWithoutPlacementAt(blockedPlacement.position).createCopyWithPlacement(movedPlacement);
  }

  return placements;
}

Position? _closestPosition(Iterable<Position> positions, {required Position to}) {
  Position? closestPosition;

  for (final position in positions) {
    final isCloser = closestPosition == null || position.distanceToPosition(to) < closestPosition.distanceToPosition(to);
    if (isCloser) closestPosition = position;
  }

  return closestPosition;
}
