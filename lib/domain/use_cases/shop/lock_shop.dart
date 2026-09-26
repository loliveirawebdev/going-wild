import '../../models/match_progress/match_progress.dart';
import '../../models/shop/errors/shop_already_locked_error.dart';

class LockShop {
  const LockShop();

  MatchProgress call(MatchProgress matchProgress) {
    matchProgress.requireInProgress();
    if (matchProgress.shop.isLocked) throw ShopAlreadyLockedError();

    return matchProgress.createCopyWith(shop: matchProgress.shop.createCopyLocked());
  }
}
