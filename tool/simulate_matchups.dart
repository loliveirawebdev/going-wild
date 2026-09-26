import 'dart:io';
import 'dart:math';

import 'package:going_wild/content/character/enemies/enemies.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/engines/combat/basic_combat_engine.dart';
import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/character/rarity.dart';
import 'package:going_wild/domain/models/combat/combat_result.dart';
import 'package:going_wild/domain/models/combat_history/entries/combat_history_entry.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';

const seeds = [1, 2, 3];
const teamDuelPosition = Position(row: 6, column: 2);
const enemyDuelPosition = Position(row: 1, column: 2);

final castsPerCharacter = <String, int>{};
final combatsPerCharacter = <String, int>{};
final combatsWithoutCastPerCharacter = <String, int>{};

void main() {
  printDuelMatrix();
  printMergeLadderByRarity();
  printRoundRobin('TEAM ROUND ROBIN (1★ duels, win rate against every other team character)', allTeamCharacters);
  printRoundRobin('ENEMY ROUND ROBIN (1★ duels, win rate against every other enemy)', allEnemyCharacters);
  printAbilityUsage();
}

CombatResult duel(Character teamCharacter, int teamStars, Character enemyCharacter, int enemyStars, int seed) => combat(
  seed: seed,
  team: [
    Placement(
      position: teamDuelPosition,
      characterCopy: CharacterCopy(stars: teamStars, character: teamCharacter),
    ),
  ],
  enemies: [
    Placement(
      position: enemyDuelPosition,
      characterCopy: CharacterCopy(stars: enemyStars, character: enemyCharacter),
    ),
  ],
);

CombatResult combat({required int seed, required List<Placement> team, required List<Placement> enemies}) {
  final result = basicCombatEngine.simulate(team: team, enemies: enemies, randomGenerator: Random(seed));
  recordAbilityUsage(result);
  return result;
}

void recordAbilityUsage(CombatResult result) {
  final castsPerCombatantId = <int, int>{};

  for (final abilityCast in result.history.entries.whereType<AbilityCastHistoryEntry>()) {
    castsPerCombatantId.update(abilityCast.combatantId, (count) => count + 1, ifAbsent: () => 1);
  }

  for (final combatant in result.combatants) {
    final characterId = combatant.characterCopy.character.id.value;
    final casts = castsPerCombatantId[combatant.id] ?? 0;

    castsPerCharacter.update(characterId, (total) => total + casts, ifAbsent: () => casts);
    combatsPerCharacter.update(characterId, (total) => total + 1, ifAbsent: () => 1);
    if (casts == 0) combatsWithoutCastPerCharacter.update(characterId, (total) => total + 1, ifAbsent: () => 1);
  }
}

double teamWinRate(Iterable<CombatResult> results) =>
    results.where((result) => result.winningFaction == Faction.team).length / results.length;

double averageSeconds(Iterable<CombatResult> results) => results.fold(0.0, (sum, result) => sum + result.elapsedSeconds) / results.length;

String percentage(double ratio) => '${(ratio * 100).round()}%'.padLeft(5);

String rarityLabel(Rarity rarity) => switch (rarity) {
  Rarity.common => 'C',
  Rarity.uncommon => 'U',
  Rarity.rare => 'R',
  Rarity.epic => 'E',
};

String characterLabel(Character character) => '${character.id.value} (${rarityLabel(character.rarity)}, ${character.role.name})';

void printHeader(String title) {
  stdout.writeln('');
  stdout.writeln('=' * 120);
  stdout.writeln(title);
  stdout.writeln('=' * 120);
}

void printDuelMatrix() {
  printHeader('DUELS 1★ vs 1★: team character (rows) win rate against each enemy (columns), then average and mean duration');
  final enemyColumns = allEnemyCharacters.map((enemy) => enemy.id.value.substring(0, min(5, enemy.id.value.length)).padLeft(6)).join();
  stdout.writeln('${''.padRight(32)}$enemyColumns   avg  seconds');

  final draws = <String>[];
  for (final teamCharacter in allTeamCharacters) {
    final cells = <String>[];
    final allResults = <CombatResult>[];
    for (final enemy in allEnemyCharacters) {
      final results = seeds.map((seed) => duel(teamCharacter, 1, enemy, 1, seed)).toList();
      allResults.addAll(results);
      cells.add(percentage(teamWinRate(results)).padLeft(6));
      if (results.any((result) => result.isDraw)) draws.add('${teamCharacter.id.value} vs ${enemy.id.value}');
    }
    final average = percentage(teamWinRate(allResults)).padLeft(6);
    final seconds = averageSeconds(allResults).toStringAsFixed(1).padLeft(8);
    stdout.writeln('${characterLabel(teamCharacter).padRight(32)}${cells.join()}$average$seconds');
  }

  final columnAverages = <String>[];
  for (final enemy in allEnemyCharacters) {
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
  final enemyRarities = Rarity.values.where((rarity) => allEnemyCharacters.any((enemy) => enemy.rarity == rarity)).toList();
  stdout.writeln('${''.padRight(20)}${enemyRarities.map((rarity) => rarity.name.padLeft(10)).join()}');

  for (final teamRarity in Rarity.values) {
    final teamCharacters = allTeamCharacters.where((character) => character.rarity == teamRarity).toList();
    if (teamCharacters.isEmpty) continue;
    for (var stars = 1; stars <= 3; stars++) {
      final cells = <String>[];
      for (final enemyRarity in enemyRarities) {
        final enemies = allEnemyCharacters.where((enemy) => enemy.rarity == enemyRarity);
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
  printHeader('ABILITY USAGE across every round above: casts per round and share of rounds with zero casts');
  final characterIds = combatsPerCharacter.keys.toList()..sort();

  for (final characterId in characterIds) {
    final combats = combatsPerCharacter[characterId]!;
    final castsPerCombat = castsPerCharacter[characterId]! / combats;
    final zeroCastShare = (combatsWithoutCastPerCharacter[characterId] ?? 0) / combats;

    stdout.writeln(
      '${characterId.padRight(16)} casts/round ${castsPerCombat.toStringAsFixed(2).padLeft(6)}   '
      'never cast in ${percentage(zeroCastShare)} of $combats rounds',
    );
  }
}
