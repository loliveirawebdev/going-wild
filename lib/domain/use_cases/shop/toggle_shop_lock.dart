import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/use_cases/shop/lock_shop.dart';
import 'package:going_wild/domain/use_cases/shop/unlock_shop.dart';

RejectedPlayerActionError? checkTogglingShopLock(MatchProgress matchProgress) =>
    matchProgress.shop.isLocked ? checkUnlockingShop(matchProgress) : checkLockingShop(matchProgress);

MatchProgress toggleShopLock(MatchProgress matchProgress) =>
    matchProgress.shop.isLocked ? unlockShop(matchProgress) : lockShop(matchProgress);
