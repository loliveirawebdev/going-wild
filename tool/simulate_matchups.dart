import 'dart:io';
import 'dart:math';

import 'package:going_wild/data/base_stats.dart';
import 'package:going_wild/data/characters/enemies/enemies.dart';
import 'package:going_wild/data/characters/team/team.dart';
import 'package:going_wild/data/merge_curves/merge_curves.dart';
import 'package:going_wild/data/rules.dart' as rules;
import 'package:going_wild/data/sets/sets.dart';
import 'package:going_wild/domain/models/combat/battle_result.dart';
import 'package:going_wild/domain/models/combat/battle_rules.dart';
import 'package:going_wild/domain/models/combat/board/board.dart';
import 'package:going_wild/domain/models/combat/board/faction.dart';
import 'package:going_wild/domain/models/combat/board/placement.dart';
import 'package:going_wild/domain/models/combat/board/position.dart';
import 'package:going_wild/domain/models/combat/events/battle_event.dart';
import 'package:going_wild/domain/models/models.dart';
import 'package:going_wild/domain/use_cases/combat/run_battle.dart';

const seeds = [1, 2, 3];
const maxSeconds = 60.0;
const teamDuelPosition = Position(row: 6, column: 2);
const enemyDuelPosition = Position(row: 1, column: 2);

final castsPerCharacter = <String, int>{};
final battlesPerCharacter = <String, int>{};
final battlesWithoutCastPerCharacter = <String, int>{};

void main() {
  printDuelMatrix();
  printMergeLadderByRarity();
  printRoundRobin('TEAM ROUND ROBIN (1★ duels, win rate against every other team character)', allTeamCharacters);
  printRoundRobin('ENEMY ROUND ROBIN (1★ duels, win rate against every other enemy)', allEnemies);
  printAbilityUsage();
}

BattleResult duel(Character teamCharacter, int teamStars, Character enemyCharacter, int enemyStars, int seed) => battle(
  team: [Placement(character: teamCharacter, stars: teamStars, position: teamDuelPosition)],
  enemies: [Placement(character: enemyCharacter, stars: enemyStars, position: enemyDuelPosition)],
  seed: seed,
);

BattleResult battle({required List<Placement> team, required List<Placement> enemies, required int seed}) {
  final result = runBattle(
    team: team,
    enemies: enemies,
    board: const Board(rows: rules.boardRows, columns: rules.boardColumns),
    rules: const BattleRules(
      tickSeconds: rules.tickSeconds,
      manaPerHit: rules.manaPerHit,
      nearbyRadius: rules.nearbyRadius,
      lowHealthTriggerPercentage: rules.lowHealthTriggerPercentage,
      maxSeconds: maxSeconds,
    ),
    baseStats: baseStats,
    mergeCurveFor: mergeCurveFor,
    sets: allSets,
    randomGenerator: Random(seed),
  );
  recordAbilityUsage([...team, ...enemies], result);
  return result;
}

void recordAbilityUsage(List<Placement> placementsInIdOrder, BattleResult result) {
  final castsPerUnitId = <int, int>{};
  for (final cast in result.events.whereType<CharacterAbilityCast>())
    castsPerUnitId.update(cast.unitId, (count) => count + 1, ifAbsent: () => 1);

  for (var index = 0; index < placementsInIdOrder.length; index++) {
    final characterId = placementsInIdOrder[index].character.id;
    final casts = castsPerUnitId[index + 1] ?? 0;
    castsPerCharacter.update(characterId, (total) => total + casts, ifAbsent: () => casts);
    battlesPerCharacter.update(characterId, (total) => total + 1, ifAbsent: () => 1);
    if (casts == 0) battlesWithoutCastPerCharacter.update(characterId, (total) => total + 1, ifAbsent: () => 1);
  }
}

double teamWinRate(Iterable<BattleResult> results) =>
    results.where((result) => result.winningFaction == Faction.team).length / results.length;

double averageSeconds(Iterable<BattleResult> results) =>
    results.map((result) => result.elapsedSeconds).reduce((a, b) => a + b) / results.length;

String percentage(double ratio) => '${(ratio * 100).round()}%'.padLeft(5);

String rarityLabel(Rarity rarity) => switch (rarity) {
  Rarity.common => 'C',
  Rarity.uncommon => 'U',
  Rarity.rare => 'R',
  Rarity.epic => 'E',
};

String characterLabel(Character character) => '${character.id} (${rarityLabel(character.rarity)}, ${character.role.name})';

void printHeader(String title) {
  stdout.writeln('');
  stdout.writeln('=' * 120);
  stdout.writeln(title);
  stdout.writeln('=' * 120);
}

void printDuelMatrix() {
  printHeader('DUELS 1★ vs 1★: team character (rows) win rate against each enemy (columns), then average and mean duration');
  final enemyColumns = allEnemies.map((enemy) => enemy.id.substring(0, min(5, enemy.id.length)).padLeft(6)).join();
  stdout.writeln('${''.padRight(32)}$enemyColumns   avg  seconds');

  final draws = <String>[];
  for (final teamCharacter in allTeamCharacters) {
    final cells = <String>[];
    final allResults = <BattleResult>[];
    for (final enemy in allEnemies) {
      final results = seeds.map((seed) => duel(teamCharacter, 1, enemy, 1, seed)).toList();
      allResults.addAll(results);
      cells.add(percentage(teamWinRate(results)).padLeft(6));
      if (results.any((result) => result.isDraw)) draws.add('${teamCharacter.id} vs ${enemy.id}');
    }
    final average = percentage(teamWinRate(allResults)).padLeft(6);
    final seconds = averageSeconds(allResults).toStringAsFixed(1).padLeft(8);
    stdout.writeln('${characterLabel(teamCharacter).padRight(32)}${cells.join()}$average$seconds');
  }

  final columnAverages = <String>[];
  for (final enemy in allEnemies) {
    final results = [
      for (final teamCharacter in allTeamCharacters)
        for (final seed in seeds) duel(teamCharacter, 1, enemy, 1, seed),
    ];
    columnAverages.add(percentage(teamWinRate(results)).padLeft(6));
  }
  stdout.writeln('${'team win rate per enemy'.padRight(32)}${columnAverages.join()}');
  if (draws.isNotEmpty) stdout.writeln('draws (60s timeout): ${draws.join(', ')}');
}

void printMergeLadderByRarity() {
  printHeader('MERGE LADDER: team win rate grouped by team rarity × stars (rows) against enemy rarity at 1★ (columns)');
  final enemyRarities = Rarity.values.where((rarity) => allEnemies.any((enemy) => enemy.rarity == rarity)).toList();
  stdout.writeln('${''.padRight(20)}${enemyRarities.map((rarity) => rarity.name.padLeft(10)).join()}');

  for (final teamRarity in Rarity.values) {
    final teamCharacters = allTeamCharacters.where((character) => character.rarity == teamRarity).toList();
    if (teamCharacters.isEmpty) continue;
    for (var stars = 1; stars <= 3; stars++) {
      final cells = <String>[];
      for (final enemyRarity in enemyRarities) {
        final enemies = allEnemies.where((enemy) => enemy.rarity == enemyRarity);
        final results = [
          for (final teamCharacter in teamCharacters)
            for (final enemy in enemies)
              for (final seed in seeds) duel(teamCharacter, stars, enemy, 1, seed),
        ];
        cells.add(percentage(teamWinRate(results)).padLeft(10));
      }
      stdout.writeln('${'${teamRarity.name} ${'★' * stars}'.padRight(20)}${cells.join()}');
    }
  }
}

void printRoundRobin(String title, List<Character> characters) {
  printHeader(title);
  final winRates = <Character, double>{};
  for (final character in characters) {
    final results = [
      for (final opponent in characters)
        if (opponent != character)
          for (final seed in seeds) duel(character, 1, opponent, 1, seed),
    ];
    winRates[character] = teamWinRate(results);
  }

  final ranking = winRates.keys.toList()..sort((first, second) => winRates[second]!.compareTo(winRates[first]!));
  for (final character in ranking) stdout.writeln('${characterLabel(character).padRight(32)}${percentage(winRates[character]!)}');
}

void printAbilityUsage() {
  printHeader('ABILITY USAGE across every battle above: casts per battle and share of battles with zero casts');
  final characterIds = battlesPerCharacter.keys.toList()..sort();
  for (final characterId in characterIds) {
    final battles = battlesPerCharacter[characterId]!;
    final castsPerBattle = castsPerCharacter[characterId]! / battles;
    final zeroCastShare = (battlesWithoutCastPerCharacter[characterId] ?? 0) / battles;
    stdout.writeln(
      '${characterId.padRight(16)} casts/battle ${castsPerBattle.toStringAsFixed(2).padLeft(6)}   never cast in ${percentage(zeroCastShare)} of $battles battles',
    );
  }
}
