import 'package:going_wild/domain/models/match_progress/match_progress.dart';

MatchProgress refreshShopOffers(MatchProgress matchProgress) {
  final engines = matchProgress.phase.engines;
  final offers = engines.shopEngine.pickOffers(matchProgress: matchProgress);
  return matchProgress.createCopyWith(shop: matchProgress.shop.createCopyWithOffers(offers));
}
