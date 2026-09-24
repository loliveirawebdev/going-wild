import 'dart:io';
import 'dart:math';

import 'package:going_wild/data/character/base_stats.dart';
import 'package:going_wild/data/character/enemies/enemies.dart';
import 'package:going_wild/data/character/merge_curves/merge_curves.dart';
import 'package:going_wild/data/character/team/team.dart';
import 'package:going_wild/data/phase/phases.dart';
import 'package:going_wild/data/combat/battle_rules.dart' as rules;
import 'package:going_wild/data/phase/phase_rules.dart' as rules;
import 'package:going_wild/data/player/player_levels.dart';
import 'package:going_wild/data/set/sets.dart';
import 'package:going_wild/data/shop/shop_rules.dart' as rules;
import 'package:going_wild/domain/models/combat/battle_rules.dart';
import 'package:going_wild/domain/models/combat/board/board.dart';
import 'package:going_wild/domain/models/combat/board/placement.dart';
import 'package:going_wild/domain/models/combat/board/position.dart';
import 'package:going_wild/domain/models/models.dart';
import 'package:going_wild/domain/models/phase/enemy_wave.dart';
import 'package:going_wild/domain/models/phase/phase.dart';
import 'package:going_wild/domain/models/phase/phase_rules.dart';
import 'package:going_wild/domain/models/phase/phase_run.dart';
import 'package:going_wild/domain/models/phase/phase_status.dart';
import 'package:going_wild/domain/models/player/team_slot/team_slot.dart';
import 'package:going_wild/domain/models/shop/owned_character.dart';
import 'package:going_wild/domain/models/shop/shop_rules.dart';
import 'package:going_wild/domain/use_cases/phase/fight_round.dart';
import 'package:going_wild/domain/use_cases/phase/start_phase.dart';
import 'package:going_wild/domain/use_cases/player/buy_experience.dart';
import 'package:going_wild/domain/use_cases/shop/buy_shop_offer.dart';
import 'package:going_wild/domain/use_cases/shop/sell_owned_character.dart';

const seedCount = 100;
const roundCount = 10;
const budgets = <(int, int)>[];
const rewards = [(9, 9), (10, 10), (11, 11), (12, 12), (8, 14)];

const phaseRules = PhaseRules(
  board: Board(rows: rules.boardRows, columns: rules.boardColumns),
  sets: allSets,
  baseStats: baseStats,
  mergeCurveFor: mergeCurveFor,
  benchSize: rules.benchSize,
  startingPlayerLives: rules.startingPlayerLives,
  battleRules: BattleRules(
    tickSeconds: rules.tickSeconds,
    manaPerHit: rules.manaPerHit,
    nearbyRadius: rules.nearbyRadius,
    lowHealthTriggerPercentage: rules.lowHealthTriggerPercentage,
    maxSeconds: 60,
  ),
  shopRules: ShopRules(
    maxStars: rules.maxStars,
    shopSize: rules.shopSize,
    playerLevels: playerLevels,
    copiesPerMerge: rules.copiesPerMerge,
    rerollCostInCoins: rules.rerollCostInCoins,
    experiencePerRound: rules.experiencePerRound,
    purchasableCharacters: allTeamCharacters,
    experiencePerPurchase: rules.experiencePerPurchase,
    experiencePurchaseCostInCoins: rules.experiencePurchaseCostInCoins,
    maxShopOddsPercentagePerCharacter: rules.maxShopOddsPercentagePerCharacter,
    mergedCharacterSellDiscountInCoins: rules.mergedCharacterSellDiscountInCoins,
  ),
);

typedef Bot = void Function(PhaseRun phaseRun, Random random);
typedef PhaseConfig = ({String name, Phase phase});
typedef Outcome = ({int wins, int livesLost, List<int> lossesPerRound, List<int> livesLostPerRound});

void main(List<String> arguments) {
  final bots = <String, Bot>{'smart': smartBot, 'greedy': greedyBot, 'random': randomBot};

  final configs = <PhaseConfig>[
    (name: 'backyard', phase: backyard),
    for (final budget in budgets)
      for (final reward in rewards)
        (
          name: 'budget ${budget.$1}+${budget.$2}/round, reward ${reward.$1}->${reward.$2}',
          phase: generatedPhase(
            id: 'b${budget.$1}_${budget.$2}_r${reward.$1}_${reward.$2}',
            startBudget: budget.$1,
            budgetGrowth: budget.$2,
            firstReward: reward.$1,
            lastReward: reward.$2,
          ),
        ),
  ];

  final wavesToPrint = arguments.indexOf('--waves');
  if (wavesToPrint != -1) {
    final chosen = configs.firstWhere((config) => config.phase.id == arguments[wavesToPrint + 1]);
    final outcome = play(chosen.phase, smartBot);
    stdout.writeln('${chosen.name}: smart wins ${outcome.wins}%');
    for (final (index, wave) in chosen.phase.enemyWaves.indexed) {
      final strength = wave.enemies.fold(0, (sum, enemy) => sum + enemy.character.rarity.coins * (1 << (enemy.stars - 1)));
      final enemies = wave.enemies.map((enemy) => '${enemy.character.id}${'*' * enemy.stars}').join(' ');
      stdout.writeln(
        'round ${'${index + 1}'.padLeft(2)}  strength ${'$strength'.padLeft(3)}  reward ${wave.coinsReward}  '
        'lives lost/run ${(outcome.livesLostPerRound[index] / seedCount).toStringAsFixed(2)}  lost here ${outcome.lossesPerRound[index]}   $enemies',
      );
    }
    if (arguments.contains('--dart')) stdout.writeln(dartSourceOf(chosen.phase));
    return;
  }

  stdout.writeln('$seedCount seeds per cell, ${phaseRules.startingPlayerLives} lives, $roundCount rounds. win% / avg lives lost');
  stdout.writeln('${'config'.padRight(44)}${bots.keys.map((name) => name.padLeft(14)).join()}   smart losses by round');
  for (final config in configs) {
    final cells = <String>[];
    var smartLosses = <int>[];
    for (final MapEntry(key: botName, value: bot) in bots.entries) {
      final outcome = play(config.phase, bot);
      cells.add('${'${outcome.wins}%'.padLeft(5)} ${(outcome.livesLost / seedCount).toStringAsFixed(2).padLeft(5)}'.padLeft(14));
      if (botName == 'smart') smartLosses = outcome.lossesPerRound;
    }
    stdout.writeln('${config.name.padRight(44)}${cells.join()}   ${smartLosses.join(' ')}');
  }
}

Outcome play(Phase phase, Bot bot) {
  var wins = 0;
  var livesLost = 0;
  final lossesPerRound = List.filled(phase.roundCount, 0);
  final livesLostPerRound = List.filled(phase.roundCount, 0);

  for (var seed = 1; seed <= seedCount; seed++) {
    final phaseRun = startPhase(phase, phaseRules, Random(seed));
    final botRandom = Random(seed * 7919);
    while (phaseRun.status == PhaseStatus.inProgress) {
      bot(phaseRun, botRandom);
      final roundResult = fightRound(phaseRun)!;
      livesLost += roundResult.livesTaken;
      livesLostPerRound[roundResult.roundNumber - 1] += roundResult.livesTaken;
      if (phaseRun.status == PhaseStatus.lost) lossesPerRound[roundResult.roundNumber - 1] += 1;
    }
    if (phaseRun.status == PhaseStatus.won) wins += 1;
  }

  return (wins: wins, livesLost: livesLost, lossesPerRound: lossesPerRound, livesLostPerRound: livesLostPerRound);
}

int strengthOf(OwnedCharacter ownedCharacter) => ownedCharacter.character.rarity.coins * (1 << (ownedCharacter.stars - 1));

List<Position> teamPositionsFrontFirst(Board board) => [
  for (var row = board.rows ~/ 2; row < board.rows; row++)
    for (final column in [2, 1, 3, 0, 4]) Position(row: row, column: column),
];

void placeOnField(PhaseRun phaseRun, List<OwnedCharacter> fielded, List<OwnedCharacter> benched, List<Position> positions) {
  final player = phaseRun.player;
  player.field.clear();
  player.bench.fillRange(0, player.bench.length, null);
  for (final (index, ownedCharacter) in fielded.indexed) player.field[positions[index]] = ownedCharacter;
  for (final (index, ownedCharacter) in benched.indexed) player.bench[index] = ownedCharacter;
}

void greedyBot(PhaseRun phaseRun, Random random) {
  final player = phaseRun.player;
  for (var offerIndex = 0; offerIndex < player.shopOffers.length; offerIndex++) buyShopOffer(phaseRun, offerIndex);
  while (player.coins >= phaseRun.rules.shopRules.experiencePurchaseCostInCoins + 6) {
    if (!buyExperience(phaseRun)) break;
  }

  final strongestFirst = [...player.ownedCharacters]..sort((first, second) => strengthOf(second).compareTo(strengthOf(first)));
  final fielded = strongestFirst.take(player.level).toList();
  placeOnField(phaseRun, fielded, strongestFirst.skip(player.level).toList(), teamPositionsFrontFirst(phaseRun.rules.board));
}

void randomBot(PhaseRun phaseRun, Random random) {
  final player = phaseRun.player;
  for (var offerIndex = 0; offerIndex < player.shopOffers.length; offerIndex++) {
    if (random.nextBool()) buyShopOffer(phaseRun, offerIndex);
  }

  final shuffled = [...player.ownedCharacters]..shuffle(random);
  final positions = [...teamPositionsFrontFirst(phaseRun.rules.board)]..shuffle(random);
  placeOnField(phaseRun, shuffled.take(player.level).toList(), shuffled.skip(player.level).toList(), positions);
}

void smartBot(PhaseRun phaseRun, Random random) {
  final player = phaseRun.player;
  final shopRules = phaseRun.rules.shopRules;

  bool completesAMerge(Character character) =>
      player.ownedCharacters.where((owned) => owned.character == character && owned.stars == 1).length >= shopRules.copiesPerMerge - 1;

  final offerIndexes =
      [
        for (var index = 0; index < player.shopOffers.length; index++)
          if (player.shopOffers[index] != null) index,
      ]..sort((first, second) {
        final firstCharacter = player.shopOffers[first]!;
        final secondCharacter = player.shopOffers[second]!;
        final mergeOrder = (completesAMerge(secondCharacter) ? 1 : 0).compareTo(completesAMerge(firstCharacter) ? 1 : 0);
        return mergeOrder != 0 ? mergeOrder : secondCharacter.rarity.coins.compareTo(firstCharacter.rarity.coins);
      });

  for (final offerIndex in offerIndexes) {
    final character = player.shopOffers[offerIndex]!;
    if (player.coins < character.rarity.coins) continue;
    if (buyShopOffer(phaseRun, offerIndex)) continue;

    final weakestBenched = player.occupiedTeamSlots
        .where((occupied) => occupied.slot is BenchSlot)
        .fold<({TeamSlot slot, OwnedCharacter ownedCharacter})?>(
          null,
          (weakest, occupied) =>
              weakest == null || strengthOf(occupied.ownedCharacter) < strengthOf(weakest.ownedCharacter) ? occupied : weakest,
        );
    if (weakestBenched == null || strengthOf(weakestBenched.ownedCharacter) >= character.rarity.coins) continue;
    sellOwnedCharacter(phaseRun, weakestBenched.slot);
    buyShopOffer(phaseRun, offerIndex);
  }

  while (player.ownedCharacters.length > player.level && player.coins >= shopRules.experiencePurchaseCostInCoins) {
    if (!buyExperience(phaseRun)) break;
  }

  final strongestFirst = [...player.ownedCharacters]..sort((first, second) => strengthOf(second).compareTo(strengthOf(first)));
  final fielded = strongestFirst.take(player.level).toList();
  bool isFrontLiner(OwnedCharacter owned) => owned.character.role == Role.tank || owned.character.role == Role.guard;
  final frontThenBack = [...fielded.where(isFrontLiner), ...fielded.where((owned) => !isFrontLiner(owned))];
  final board = phaseRun.rules.board;
  final frontRow = board.rows ~/ 2;
  final positions = [
    for (final column in [2, 1, 3, 0, 4]) Position(row: frontRow, column: column),
    for (var row = frontRow + 2; row < board.rows; row++)
      for (final column in [2, 1, 3, 0, 4]) Position(row: row, column: column),
    for (final column in [2, 1, 3, 0, 4]) Position(row: frontRow + 1, column: column),
  ];
  placeOnField(phaseRun, frontThenBack, strongestFirst.skip(player.level).toList(), positions);
}

Phase generatedPhase({
  required String id,
  required int startBudget,
  required int budgetGrowth,
  required int firstReward,
  required int lastReward,
}) {
  final random = Random(id.hashCode);
  const unlockRound = {Rarity.common: 1, Rarity.uncommon: 2, Rarity.rare: 4, Rarity.epic: 7};
  const maxEnemies = 6;

  int costOf(Character character, int stars) => character.rarity.coins * (1 << (stars - 1));

  final waves = <EnemyWave>[];
  for (var round = 1; round <= roundCount; round++) {
    var budget = startBudget + budgetGrowth * (round - 1);
    final allowed = allEnemies.where((enemy) => unlockRound[enemy.rarity]! <= round).toList();
    final picked = <(Character, int)>[];

    while (picked.length < maxEnemies) {
      final affordable = allowed.where((enemy) => costOf(enemy, 1) <= budget).toList();
      if (affordable.isEmpty) break;
      final enemy = affordable[random.nextInt(affordable.length)];
      picked.add((enemy, 1));
      budget -= costOf(enemy, 1);
    }

    var upgradedSomething = true;
    while (upgradedSomething) {
      upgradedSomething = false;
      final upgradable = [
        for (final (index, (enemy, stars)) in picked.indexed)
          if (stars < rules.maxStars && costOf(enemy, stars + 1) - costOf(enemy, stars) <= budget) index,
      ];
      if (upgradable.isEmpty) break;
      final index = upgradable[random.nextInt(upgradable.length)];
      final (enemy, stars) = picked[index];
      budget -= costOf(enemy, stars + 1) - costOf(enemy, stars);
      picked[index] = (enemy, stars + 1);
      upgradedSomething = true;
    }

    final reward = firstReward + ((lastReward - firstReward) * (round - 1) / (roundCount - 1)).round();
    waves.add(waveFrom(picked, reward));
  }

  return Phase(id: id, enemyWaves: waves);
}

EnemyWave waveFrom(List<(Character, int)> picks, int reward) {
  bool isFrontLiner(Character character) => character.role == Role.tank || character.role == Role.guard;
  final ordered = [...picks.where((pick) => isFrontLiner(pick.$1)), ...picks.where((pick) => !isFrontLiner(pick.$1))];
  const columns = [2, 1, 3, 0, 4];
  final positions = [
    for (final column in columns) Position(row: 3, column: column),
    for (final column in columns) Position(row: 1, column: column),
  ];
  return EnemyWave(
    coinsReward: reward,
    enemies: [for (final (index, (enemy, stars)) in ordered.indexed) Placement(character: enemy, stars: stars, position: positions[index])],
  );
}

Phase handmadePhase(String id, List<int> rewards, List<List<(Character, int)>> waves) =>
    Phase(id: id, enemyWaves: [for (final (index, picks) in waves.indexed) waveFrom(picks, rewards[index])]);

String dartSourceOf(Phase phase) {
  final buffer = StringBuffer('  enemyWaves: [\n');
  for (final wave in phase.enemyWaves) {
    buffer.writeln('    EnemyWave(\n      coinsReward: ${wave.coinsReward},\n      enemies: [');
    for (final enemy in wave.enemies) {
      buffer.writeln(
        '        Placement(character: ${enemy.character.id.replaceAllMapped(RegExp(r'_(\w)'), (match) => match.group(1)!.toUpperCase())}, '
        'stars: ${enemy.stars}, position: Position(row: ${enemy.position.row}, column: ${enemy.position.column})),',
      );
    }
    buffer.writeln('      ],\n    ),');
  }
  buffer.writeln('  ],');
  return buffer.toString();
}
