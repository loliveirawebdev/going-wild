import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/engines/level/basic_level_engine.dart';
import 'package:going_wild/content/level/player_levels.dart';
import 'package:going_wild/domain/models/level/engines/basic_level_engine.dart';
import 'package:going_wild/domain/models/level/errors/unknown_player_level_error.dart';
import 'package:going_wild/domain/models/level/player_level.dart';
import 'package:going_wild/domain/models/level/player_level_progress.dart';

PlayerLevel levelNumbered(int levelNumber) => playerLevels.firstWhere((playerLevel) => playerLevel.number == levelNumber);

int experienceToLeave(int levelNumber) => levelNumbered(levelNumber).experienceToNextLevel;

PlayerLevelProgress gain(int experienceAmount, {required int levelNumber, int experience = 0}) {
  final playerLevelProgress = PlayerLevelProgress(experience: experience, level: levelNumbered(levelNumber));
  return basicLevelEngine.gainExperience(playerLevelProgress, experienceAmount);
}

void main() {
  final maxLevelNumber = playerLevels.last.number;

  test('experience below the threshold keeps the level', () {
    final playerLevelProgress = gain(experienceToLeave(4) - 1, levelNumber: 4);

    expect(playerLevelProgress.level.number, 4);
    expect(playerLevelProgress.experience, experienceToLeave(4) - 1);
  });

  test('reaching the threshold levels up and keeps the leftover', () {
    final playerLevelProgress = gain(experienceToLeave(4), experience: 3, levelNumber: 4);

    expect(playerLevelProgress.level.number, 5);
    expect(playerLevelProgress.experience, 3);
  });

  test('a big amount climbs several levels at once', () {
    final playerLevelProgress = gain(experienceToLeave(1) + experienceToLeave(2) + experienceToLeave(3) + 1, levelNumber: 1);

    expect(playerLevelProgress.level.number, 4);
    expect(playerLevelProgress.experience, 1);
  });

  test('reaching max level clears the leftover', () {
    final playerLevelProgress = gain(experienceToLeave(maxLevelNumber - 1) + 50, levelNumber: maxLevelNumber - 1);

    expect(playerLevelProgress.level.number, maxLevelNumber);
    expect(playerLevelProgress.experience, 0);
  });

  test('at max level experience is ignored', () {
    final playerLevelProgress = gain(100, levelNumber: maxLevelNumber);

    expect(playerLevelProgress.level.number, maxLevelNumber);
    expect(playerLevelProgress.experience, 0);
  });

  test('only the last level is the max level', () {
    expect(basicLevelEngine.isMaxLevel(levelNumbered(maxLevelNumber)), isTrue);
    expect(basicLevelEngine.isMaxLevel(levelNumbered(maxLevelNumber - 1)), isFalse);
  });

  test('a new game starts at the first level with no experience', () {
    final startingProgress = basicLevelEngine.startingProgress();

    expect(startingProgress.level.number, 1);
    expect(startingProgress.experience, 0);
  });

  test('a level outside the configured levels fails', () {
    const unknownLevel = PlayerLevel(number: 99, teamSize: 99, experienceToNextLevel: 1);
    const shortLevelEngine = BasicLevelEngine(
      experiencePerRound: 2,
      playerLevels: [PlayerLevel(number: 1, teamSize: 1, experienceToNextLevel: 2)],
    );

    expect(() => shortLevelEngine.isMaxLevel(unknownLevel), throwsA(isA<UnknownPlayerLevelError>()));
    expect(
      () => shortLevelEngine.gainExperience(const PlayerLevelProgress(experience: 0, level: unknownLevel), 1),
      throwsA(isA<UnknownPlayerLevelError>()),
    );
  });
}
