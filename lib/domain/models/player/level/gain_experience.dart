import '../../events/phase/phase_event.dart';
import '../../phase/phase_run.dart';

void gainExperience(PhaseRun phaseRun, int experienceAmount) {
  final player = phaseRun.player;
  final rules = phaseRun.rules.shopRules;
  if (player.level >= rules.maxLevel) return;

  player.experience += experienceAmount;
  final newLevels = <int>[];

  while (player.level < rules.maxLevel && player.experience >= rules.playerLevels[player.level - 1].experienceToNextLevel) {
    player.experience -= rules.playerLevels[player.level - 1].experienceToNextLevel;
    player.level += 1;
    newLevels.add(player.level);
  }

  if (player.level >= rules.maxLevel) player.experience = 0;

  final roundNumber = phaseRun.currentRoundNumber;

  phaseRun.recordEvent(
    PlayerReceivedExperience(
      roundNumber: roundNumber,
      amount: experienceAmount,
      experienceAfterReceived: player.experience,
    ),
  );

  for (final newLevel in newLevels) phaseRun.recordEvent(PlayerLeveledUp(roundNumber: roundNumber, newLevel: newLevel));
}
