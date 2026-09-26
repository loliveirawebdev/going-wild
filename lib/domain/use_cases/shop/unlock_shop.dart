import '../../models/match_progress/match_progress.dart';
import '../../models/shop/errors/shop_already_unlocked_error.dart';

class UnlockShop {
  const UnlockShop();

  MatchProgress call(MatchProgress matchProgress) {
    matchProgress.requireInProgress();
    if (!matchProgress.shop.isLocked) throw ShopAlreadyUnlockedError();

    return matchProgress.createCopyWith(shop: matchProgress.shop.createCopyUnlocked());
  }
}
