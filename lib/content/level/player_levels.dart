import 'package:going_wild/domain/models/level/player_level.dart';

const List<PlayerLevel> playerLevels = [
  PlayerLevel(number: 1, teamSize: 1, experienceToNextLevel: 2),
  PlayerLevel(number: 2, teamSize: 2, experienceToNextLevel: 2),
  PlayerLevel(number: 3, teamSize: 3, experienceToNextLevel: 6),
  PlayerLevel(number: 4, teamSize: 4, experienceToNextLevel: 10),
  PlayerLevel(number: 5, teamSize: 5, experienceToNextLevel: 20),
  PlayerLevel(number: 6, teamSize: 6, experienceToNextLevel: 36),
  PlayerLevel(number: 7, teamSize: 7, experienceToNextLevel: 48),
  PlayerLevel(number: 8, teamSize: 8, experienceToNextLevel: 76),
  PlayerLevel(number: 9, teamSize: 9, experienceToNextLevel: 84),
  PlayerLevel(number: 10, teamSize: 10, experienceToNextLevel: 0),
];
