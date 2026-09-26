import '../../models/board/errors/no_placement_at_position_error.dart';
import '../../models/board/placement_list.dart';
import '../../models/board/position.dart';
import '../../models/match_progress/match_progress.dart';

class SellFromBoard {
  const SellFromBoard();

  MatchProgress call(MatchProgress matchProgress, {required Position position}) {
    matchProgress.requireInProgress();
    final roster = matchProgress.playerRoster;
    final engines = matchProgress.phase.engines;

    final soldPlacement = roster.placements.placementAt(position);
    if (soldPlacement == null) throw NoPlacementAtPositionError(position: position);

    final copiesInside = engines.mergeEngine.copiesInside(soldPlacement.characterCopy.stars);
    final sellPrice = engines.economyEngine.sellPriceOf(soldPlacement.characterCopy, copiesInside: copiesInside);

    final playerAfterSale = matchProgress.player.createCopyWithCoinsReceived(sellPrice);
    final placementsAfterSale = roster.placements.createCopyWithoutPlacementAt(position);

    final rosterAfterSale = roster.createCopyWith(placements: placementsAfterSale);

    return matchProgress.createCopyWith(
      player: playerAfterSale,
      playerRoster: rosterAfterSale,
    );
  }
}
