import 'package:going_wild/domain/models/level/errors/max_level_reached_error.dart';
import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/player/errors/not_enough_coins_error.dart';

RejectedPlayerActionError? checkBuyingExperience(MatchProgress matchProgress) {
  if (matchProgress.checkPreparingActions() case final rejection?) return rejection;

  final player = matchProgress.player;
  final engines = matchProgress.phase.engines;
  final level = matchProgress.playerLevelProgress.level;
  final cost = engines.economyEngine.experiencePurchaseCostInCoins(matchProgress: matchProgress);
  if (!player.canAfford(cost)) return NotEnoughCoinsError(costInCoins: cost, coins: player.coins);
  if (engines.levelEngine.isMaxLevel(level)) return MaxLevelReachedError(maxLevel: level.number);

  return null;
}

MatchProgress buyExperience(MatchProgress matchProgress) {
  if (checkBuyingExperience(matchProgress) case final rejection?) throw rejection;
  final engines = matchProgress.phase.engines;
  final economyEngine = engines.economyEngine;

  final cost = economyEngine.experiencePurchaseCostInCoins(matchProgress: matchProgress);
  final experienceAmount = economyEngine.experiencePerPurchase(matchProgress: matchProgress);

  return matchProgress.createCopyWith(
    player: matchProgress.player.createCopyWithCoinsSpent(cost),
    playerLevelProgress: engines.levelEngine.gainExperience(matchProgress.playerLevelProgress, experienceAmount),
  );
}
