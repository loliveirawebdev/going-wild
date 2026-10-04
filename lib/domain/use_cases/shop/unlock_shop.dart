import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/shop/errors/shop_already_unlocked_error.dart';

RejectedPlayerActionError? checkUnlockingShop(MatchProgress matchProgress) {
  if (matchProgress.checkPreparingActions() case final rejection?) return rejection;
  if (!matchProgress.shop.isLocked) return ShopAlreadyUnlockedError();

  return null;
}

MatchProgress unlockShop(MatchProgress matchProgress) {
  if (checkUnlockingShop(matchProgress) case final rejection?) throw rejection;
  return matchProgress.createCopyWith(shop: matchProgress.shop.createCopyUnlocked());
}
