import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/shop/errors/shop_already_locked_error.dart';

RejectedPlayerActionError? checkLockingShop(MatchProgress matchProgress) {
  if (matchProgress.checkPreparingActions() case final rejection?) return rejection;
  if (matchProgress.shop.isLocked) return ShopAlreadyLockedError();

  return null;
}

MatchProgress lockShop(MatchProgress matchProgress) {
  if (checkLockingShop(matchProgress) case final rejection?) throw rejection;

  return matchProgress.createCopyWith(shop: matchProgress.shop.createCopyLocked());
}
