import 'package:going_wild/domain/models/board/errors/no_placement_at_position_error.dart';
import 'package:going_wild/domain/models/board/placement_list.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';

RejectedPlayerActionError? checkSellingFromBoard(MatchProgress matchProgress, {required Position position}) {
  if (matchProgress.checkPreparingActions() case final rejection?) return rejection;
  if (matchProgress.playerRoster.placements.placementAt(position) == null) return NoPlacementAtPositionError(position: position);

  return null;
}

MatchProgress sellFromBoard(MatchProgress matchProgress, {required Position position}) {
  if (checkSellingFromBoard(matchProgress, position: position) case final rejection?) throw rejection;
  final roster = matchProgress.playerRoster;
  final engines = matchProgress.phase.engines;

  final soldPlacement = roster.placements.placementAt(position)!;
  final sellPrice = engines.economyEngine.sellPriceOf(soldPlacement.characterCopy, matchProgress: matchProgress);

  final playerAfterSale = matchProgress.player.createCopyWithCoinsReceived(sellPrice);
  final placementsAfterSale = roster.placements.createCopyWithoutPlacementAt(position);

  final rosterAfterSale = roster.createCopyWith(placements: placementsAfterSale);

  return matchProgress.createCopyWith(
    player: playerAfterSale,
    playerRoster: rosterAfterSale,
  );
}
