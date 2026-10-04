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
  );

  if (rewardedMatchProgress.shop.isLocked) return rewardedMatchProgress;
  return refreshShopOffers(rewardedMatchProgress);
}
