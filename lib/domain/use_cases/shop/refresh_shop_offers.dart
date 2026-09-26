import '../../models/match_progress/match_progress.dart';

class RefreshShopOffers {
  const RefreshShopOffers();

  MatchProgress call(MatchProgress matchProgress) {
    final engines = matchProgress.phase.engines;

    final offers = engines.shopEngine.pickOffers(
      roster: matchProgress.playerRoster,
      maxStars: engines.characterEngine.maxStars,
      randomGenerator: matchProgress.randomGenerator,
      levelNumber: matchProgress.playerLevelProgress.level.number,
    );

    return matchProgress.createCopyWith(shop: matchProgress.shop.createCopyWithOffers(offers));
  }
}
