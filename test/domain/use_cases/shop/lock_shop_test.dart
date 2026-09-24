import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/character/team/team.dart';
import 'package:going_wild/domain/models/events/phase/phase_event.dart';
import 'package:going_wild/domain/models/phase/enemy_wave.dart';
import 'package:going_wild/domain/models/phase/phase_status.dart';
import 'package:going_wild/domain/use_cases/phase/start_round.dart';
import 'package:going_wild/domain/use_cases/shop/lock_shop.dart';
import 'package:going_wild/domain/use_cases/shop/reroll_shop.dart';
import 'package:going_wild/domain/use_cases/shop/unlock_shop.dart';

import '../../../helpers/phase_helpers.dart';

void main() {
  test('locking and unlocking flip the lock and record it', () {
    final phaseRun = phaseRunWith();

    expect(lockShop(phaseRun), isTrue);
    expect(phaseRun.player.isShopLocked, isTrue);
    expect(unlockShop(phaseRun), isTrue);
    expect(phaseRun.player.isShopLocked, isFalse);
    expect(phaseRun.events, [isA<ShopLocked>(), isA<ShopUnlocked>()]);
  });

  test('locking a locked shop or unlocking an unlocked one does nothing', () {
    final phaseRun = phaseRunWith();

    expect(unlockShop(phaseRun), isFalse);
    lockShop(phaseRun);
    expect(lockShop(phaseRun), isFalse);
    expect(phaseRun.events.whereType<ShopLocked>(), hasLength(1));
  });

  test('a locked shop keeps its offers when the next round starts and stays locked', () {
    final phaseRun = phaseRunWith(level: 5, shopOffers: [cat, null, cow, dog]);
    lockShop(phaseRun);

    startRound(phaseRun);

    expect(phaseRun.player.shopOffers, [cat, null, cow, dog]);
    expect(phaseRun.player.isShopLocked, isTrue);
    expect(phaseRun.events.whereType<ShopOffersRefreshed>(), isEmpty);
  });

  test('rerolling a locked shop unlocks it', () {
    final phaseRun = phaseRunWith(coins: 10, level: 5, shopOffers: [cat, cat, cat, cat]);
    lockShop(phaseRun);

    rerollShop(phaseRun);

    expect(phaseRun.player.isShopLocked, isFalse);
    expect(phaseRun.events, [isA<ShopLocked>(), isA<ShopUnlocked>(), isA<ShopOffersRefreshed>()]);
  });

  test('the round wave reward still arrives with a locked shop', () {
    final phaseRun = phaseRunWith(
      coins: 0,
      enemyWaves: [
        EnemyWave(coinsReward: 6, enemies: [placed(cat, 1, 2)]),
      ],
    );
    lockShop(phaseRun);

    startRound(phaseRun);

    expect(phaseRun.player.coins, 6);
  });

  test('the lock cannot change once the phase is over', () {
    final phaseRun = phaseRunWith()..status = PhaseStatus.lost;

    expect(lockShop(phaseRun), isFalse);
    phaseRun.player.isShopLocked = true;
    expect(unlockShop(phaseRun), isFalse);
    expect(phaseRun.player.isShopLocked, isTrue);
    expect(phaseRun.events, isEmpty);
  });
}
