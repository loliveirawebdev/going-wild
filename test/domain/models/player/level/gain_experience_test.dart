import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/domain/models/events/phase/phase_event.dart';
import 'package:going_wild/domain/models/player/level/gain_experience.dart';

import '../../../../helpers/phase_helpers.dart';
import '../../../../helpers/shop_helpers.dart';

void main() {
  int experienceToLeave(int level) => testShopRules.playerLevels[level - 1].experienceToNextLevel;

  test('experience below the threshold keeps the level', () {
    final phaseRun = phaseRunWith(level: 4);

    gainExperience(phaseRun, experienceToLeave(4) - 1);

    expect(phaseRun.player.level, 4);
    expect(phaseRun.player.experience, experienceToLeave(4) - 1);
  });

  test('reaching the threshold levels up and keeps the leftover', () {
    final phaseRun = phaseRunWith(level: 4, experience: 3);

    gainExperience(phaseRun, experienceToLeave(4));

    expect(phaseRun.player.level, 5);
    expect(phaseRun.player.experience, 3);
  });

  test('a big amount climbs several levels at once', () {
    final phaseRun = phaseRunWith(level: 1);

    gainExperience(phaseRun, experienceToLeave(1) + experienceToLeave(2) + experienceToLeave(3) + 1);

    expect(phaseRun.player.level, 4);
    expect(phaseRun.player.experience, 1);
  });

  test('records the experience received and then one event per level gained', () {
    final phaseRun = phaseRunWith(level: 1);
    final experienceAmount = experienceToLeave(1) + experienceToLeave(2) + 1;

    gainExperience(phaseRun, experienceAmount);

    final received = phaseRun.events.first as PlayerReceivedExperience;
    expect(received.amount, experienceAmount);
    expect(received.experienceAfterReceived, 1);
    expect(phaseRun.events.skip(1).map((event) => (event as PlayerLeveledUp).newLevel), [2, 3]);
  });

  test('reaching max level clears the leftover', () {
    final phaseRun = phaseRunWith(level: testShopRules.maxLevel - 1);

    gainExperience(phaseRun, experienceToLeave(testShopRules.maxLevel - 1) + 50);

    expect(phaseRun.player.level, testShopRules.maxLevel);
    expect(phaseRun.player.experience, 0);
  });

  test('at max level experience is ignored and nothing is recorded', () {
    final phaseRun = phaseRunWith(level: testShopRules.maxLevel);

    gainExperience(phaseRun, 100);

    expect(phaseRun.player.level, testShopRules.maxLevel);
    expect(phaseRun.player.experience, 0);
    expect(phaseRun.events, isEmpty);
  });
}
