import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/phase/phases.dart';
import 'package:going_wild/domain/models/events/phase/phase_event.dart';
import 'package:going_wild/domain/models/phase/phase_status.dart';
import 'package:going_wild/domain/use_cases/phase/start_phase.dart';

import '../../../helpers/phase_helpers.dart';
import '../../../helpers/shop_helpers.dart';

void main() {
  final phaseRules = phaseRulesWith();

  test('a new phase starts at round 1 with every life', () {
    final phaseRun = startPhase(backyard, phaseRules, Random(1));

    expect(phaseRun.phase, backyard);
    expect(phaseRun.currentRoundNumber, 1);
    expect(phaseRun.remainingLives, phaseRules.startingPlayerLives);
    expect(phaseRun.status, PhaseStatus.inProgress);
    expect(phaseRun.currentEnemyWave, backyard.enemyWaves.first);
  });

  test('the first round is already open: coins paid, experience given and shop filled', () {
    final phaseRun = startPhase(backyard, phaseRules, Random(1));

    expect(phaseRun.player.coins, testShopRules.coinsPerRound);
    expect(phaseRun.player.level, 2);
    expect(phaseRun.player.shopOffers, hasLength(testShopRules.shopSize));
    expect(phaseRun.player.shopOffers, everyElement(isNotNull));
  });

  test('the first events are the opening of round 1', () {
    final phaseRun = startPhase(backyard, phaseRules, Random(1));

    expect(phaseRun.events.first, isA<RoundStarted>());
    expect(phaseRun.events, everyElement(predicate<PhaseEvent>((event) => event.roundNumber == 1)));
    expect(phaseRun.events.whereType<PlayerLeveledUp>().single.newLevel, 2);
    expect(phaseRun.events.last, isA<ShopOffersRefreshed>());
  });
}
