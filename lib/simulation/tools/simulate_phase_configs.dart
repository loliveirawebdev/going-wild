import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:going_wild/content/engines/basic_phase_engines.dart';
import 'package:going_wild/content/engines/player/basic_player_engine.dart';
import 'package:going_wild/content/phase/phases.dart';
import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/phase/phase.dart';
import 'package:going_wild/domain/models/phase/phase_id.dart';
import 'package:going_wild/domain/models/phase/phase_status.dart';
import 'package:going_wild/domain/models/phase/phase_wave.dart';
import 'package:going_wild/domain/use_cases/round/fight_round.dart';
import 'package:going_wild/domain/use_cases/round/start_match.dart';
import 'package:going_wild/simulation/bots/bot_profile.dart';
import 'package:going_wild/simulation/bots/bot_profiles.dart';

const runsPerProfile = 1000;

typedef Report = ({int wins, String profileName, List<int> reachedPerRound, List<int> gameOversPerRound, List<int> lostRoundsPerRound});
typedef NamedPhase = ({String name, Phase phase});

final candidatePhases = <NamedPhase>[];

Future<void> main(List<String> arguments) async {
  final onlyIndex = arguments.indexOf('--only');
  final selectedProfiles = onlyIndex == -1
      ? allBotProfiles
      : allBotProfiles.where((botProfile) => arguments[onlyIndex + 1].split(',').contains(botProfile.name)).toList();
  final phases = <NamedPhase>[for (final phase in allPhases) (name: phase.id.value, phase: phase), ...candidatePhases];

  final wavesIndex = arguments.indexOf('--waves');
  if (wavesIndex != -1) {
    final phase = phases.firstWhere((namedPhase) => namedPhase.name == arguments[wavesIndex + 1]).phase;
    printWaves(phase, printDartSource: arguments.contains('--dart'));
    return;
  }

  for (final (:name, :phase) in phases) {
    stdout.writeln('phase $name: $runsPerProfile runs per profile, ${basicPlayerEngine.startingLives} lives, ${phase.roundCount} rounds');

    final reports = await Future.wait([for (final botProfile in selectedProfiles) Isolate.run(() => play(phase, botProfile))]);
    for (final (index, report) in reports.indexed) printReport(selectedProfiles[index], report, phase.roundCount);
  }
}

void printWaves(Phase phase, {required bool printDartSource}) {
  for (final (index, wave) in phase.waves.indexed) {
    final enemies = wave.enemies.map((enemy) => '${enemy.characterCopy.character.id.value}${'*' * enemy.characterCopy.stars}').join(' ');
    stdout.writeln('round ${'${index + 1}'.padLeft(2)}  reward ${wave.coinsReward}  $enemies');
  }

  if (printDartSource) stdout.writeln(dartSourceOf(phase));
}

Report play(Phase phase, BotProfile botProfile) {
  var wins = 0;
  final reachedPerRound = List.filled(phase.roundCount, 0);
  final gameOversPerRound = List.filled(phase.roundCount, 0);
  final lostRoundsPerRound = List.filled(phase.roundCount, 0);

  for (var seed = 1; seed <= runsPerProfile; seed++) {
    final botRandom = Random(seed * 7919);
    var matchProgress = startMatch(phase, randomGenerator: Random(seed));

    while (matchProgress.isInProgress) {
      final roundIndex = matchProgress.currentRoundNumber - 1;
      reachedPerRound[roundIndex] += 1;

      final playedMatchProgress = botProfile.playRound(matchProgress, botRandom);
      final fought = fightRound(playedMatchProgress, recordsHistory: false);
      matchProgress = fought.matchProgress;

      if (fought.combatResult.isLost) lostRoundsPerRound[roundIndex] += 1;
      if (matchProgress.status == PhaseStatus.lost) gameOversPerRound[roundIndex] += 1;
    }

    if (matchProgress.status == PhaseStatus.won) wins += 1;
  }

  return (
    wins: wins,
    profileName: botProfile.name,
    reachedPerRound: reachedPerRound,
    gameOversPerRound: gameOversPerRound,
    lostRoundsPerRound: lostRoundsPerRound,
  );
}

void printReport(BotProfile botProfile, Report report, int roundCount) {
  String percentage(int count, int total) => total == 0 ? '   -  ' : '${(count / total * 100).toStringAsFixed(1)}%'.padLeft(6);
  final totalLostRounds = report.lostRoundsPerRound.fold(0, (sum, count) => sum + count);
  final lostRoundsPerRun = (totalLostRounds / runsPerProfile).toStringAsFixed(2);

  stdout.writeln('');
  stdout.writeln('== ${botProfile.name}: ${botProfile.description}');
  stdout.writeln('   wins ${percentage(report.wins, runsPerProfile)}   rounds lost per run $lostRoundsPerRun');
  stdout.writeln('   round   reached   lost the round   game over here');

  for (var roundIndex = 0; roundIndex < roundCount; roundIndex++) {
    final reached = report.reachedPerRound[roundIndex];
    final lostTheRound = percentage(report.lostRoundsPerRound[roundIndex], reached).padLeft(14);
    final gameOverHere = percentage(report.gameOversPerRound[roundIndex], runsPerProfile).padLeft(14);

    stdout.writeln('   ${'${roundIndex + 1}'.padLeft(5)}   ${percentage(reached, runsPerProfile)}   $lostTheRound   $gameOverHere');
  }
}

const meleeColumnsByRow = {
  3: [2, 1, 3],
  2: [1, 3],
  1: [1, 3],
  0: [2, 1, 3, 0, 4],
};
const rangedColumnsByRow = {
  0: [2, 1, 3, 0, 4],
  1: [1, 3],
  2: [1, 3],
  3: [2, 1, 3],
};

List<Position> positionsFrom(Map<int, List<int>> columnsByRow) => [
  for (final MapEntry(key: row, value: columns) in columnsByRow.entries)
    for (final column in columns) Position(row: row, column: column),
];

bool isRanged(Character character) => basicPhaseEngines.characterEngine.statsAtStars(character, stars: 1).isRanged;

PhaseWave waveFrom(List<CharacterCopy> enemyCopies, int coinsReward) {
  final takenPositions = <Position>{};

  Position nextFreePositionFrom(List<Position> positions) {
    final position = positions.firstWhere((candidate) => !takenPositions.contains(candidate));
    takenPositions.add(position);

    return position;
  }

  final meleeCopies = enemyCopies.where((characterCopy) => !isRanged(characterCopy.character));
  final rangedCopies = enemyCopies.where((characterCopy) => isRanged(characterCopy.character));
  final meleePositions = positionsFrom(meleeColumnsByRow);
  final rangedPositions = positionsFrom(rangedColumnsByRow);

  return PhaseWave(
    coinsReward: coinsReward,
    enemies: [
      for (final characterCopy in meleeCopies) Placement(position: nextFreePositionFrom(meleePositions), characterCopy: characterCopy),
      for (final characterCopy in rangedCopies) Placement(position: nextFreePositionFrom(rangedPositions), characterCopy: characterCopy),
    ],
  );
}

Phase handmadePhase(List<int> coinsRewards, List<List<CharacterCopy>> waves) => Phase(
  id: const PhaseId('backyard'),
  engines: basicPhaseEngines,
  waves: [for (final (index, enemyCopies) in waves.indexed) waveFrom(enemyCopies, coinsRewards[index])],
);

String dartSourceOf(Phase phase) {
  final buffer = StringBuffer();
  final phaseName = phase.id.value;

  for (final (index, wave) in phase.waves.indexed) {
    final waveNumber = index + 1;

    buffer.writeln('== lib/content/phase/$phaseName/wave_$waveNumber.dart');
    buffer.writeln('const PhaseWave ${phaseName}Wave$waveNumber = PhaseWave(');
    buffer.writeln('  coinsReward: ${wave.coinsReward},');
    buffer.writeln('  enemies: [');

    for (final enemy in wave.enemies) {
      final characterCopy = enemy.characterCopy;
      final characterName = characterCopy.character.id.value;

      buffer.writeln('    Placement(');
      buffer.writeln('      position: Position(row: ${enemy.position.row}, column: ${enemy.position.column}),');
      buffer.writeln('      characterCopy: CharacterCopy(character: $characterName, stars: ${characterCopy.stars}),');
      buffer.writeln('    ),');
    }

    buffer.writeln('  ],');
    buffer.writeln(');');
    buffer.writeln('');
  }

  return buffer.toString();
}
