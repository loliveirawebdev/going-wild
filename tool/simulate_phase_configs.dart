import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:going_wild/data/character/base_stats.dart';
import 'package:going_wild/data/character/merge_curves/merge_curves.dart';
import 'package:going_wild/data/character/team/team.dart';
import 'package:going_wild/data/combat/battle_rules.dart' as rules;
import 'package:going_wild/data/phase/phase_rules.dart' as rules;
import 'package:going_wild/data/phase/phases.dart';
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
import 'package:going_wild/domain/use_cases/shop/reroll_shop.dart';
import 'package:going_wild/domain/use_cases/shop/sell_owned_character.dart';

const runsPerProfile = 1000;

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

typedef Shopping = void Function(PhaseRun phaseRun, Random random);
typedef Placement2 = void Function(PhaseRun phaseRun, Random random);
typedef Profile = ({String name, String description, Shopping shopping, Placement2 placement});
typedef Report = ({String profileName, int wins, List<int> lostRoundsPerRound, List<int> gameOversPerRound, List<int> reachedPerRound});

final profiles = <Profile>[
  (
    name: 'smart',
    description: 'compra merges e caros, vende fraco, XP quando sobra boneco, tanque na frente',
    shopping: smartShopping,
    placement: rolesPlacement,
  ),
  (
    name: 'smart, random placement',
    description: 'compra como o smart, mas posiciona ao acaso',
    shopping: smartShopping,
    placement: randomPlacement,
  ),
  (
    name: 'greedy',
    description: 'compra tudo, XP quando sobra, mais fortes na frente sem olhar papel',
    shopping: buyEverythingThenExperience,
    placement: strongestFrontFirst,
  ),
  (
    name: 'greedy, back row',
    description: 'compra tudo, todo mundo na ultima fileira',
    shopping: buyEverythingThenExperience,
    placement: backRowOnly,
  ),
  (name: 'hoarder', description: 'compra tudo, nunca compra XP', shopping: buyEverything, placement: rolesPlacement),
  (
    name: 'leveler',
    description: 'toda moeda em XP primeiro, compra com o que sobra',
    shopping: experienceFirstThenEverything,
    placement: rolesPlacement,
  ),
  (
    name: 'reroller',
    description: 'dois rerolls por round antes de comprar tudo',
    shopping: rerollTwiceThenBuyEverything,
    placement: rolesPlacement,
  ),
  (name: 'commons only', description: 'so compra personagem de 1 moeda', shopping: buyOnlyCommons, placement: rolesPlacement),
  (name: 'front liners only', description: 'so compra tanque e guarda', shopping: buyOnlyFrontLiners, placement: rolesPlacement),
  (name: 'damage only', description: 'so compra dano e suporte', shopping: buyOnlyBackLiners, placement: rolesPlacement),
  (
    name: 'weak board',
    description: 'compra tudo, deixa duas vagas do campo vazias',
    shopping: buyEverythingThenExperience,
    placement: leaveTwoSlotsEmpty,
  ),
  (
    name: 'random',
    description: 'compra metade das ofertas ao acaso, nunca XP, posiciona ao acaso',
    shopping: buyHalfAtRandom,
    placement: randomPlacement,
  ),
];

List<(Character, int)> picksOf(EnemyWave wave) => wave.enemies.map((enemy) => (enemy.character, enemy.stars)).toList();

final candidatePhases = <Phase>[];

Future<void> main(List<String> arguments) async {
  final onlyIndex = arguments.indexOf('--only');
  final selectedProfiles = onlyIndex == -1
      ? profiles
      : profiles.where((profile) => arguments[onlyIndex + 1].split(',').contains(profile.name)).toList();
  final phases = [...allPhases, ...candidatePhases];

  final wavesToPrint = arguments.indexOf('--waves');
  if (wavesToPrint != -1) {
    final phase = phases.firstWhere((phase) => phase.id == arguments[wavesToPrint + 1]);
    for (final (index, wave) in phase.enemyWaves.indexed) {
      final enemies = wave.enemies.map((enemy) => '${enemy.character.id}${'*' * enemy.stars}').join(' ');
      stdout.writeln('round ${'${index + 1}'.padLeft(2)}  reward ${wave.coinsReward}  $enemies');
    }
    if (arguments.contains('--dart')) stdout.writeln(dartSourceOf(phase));
    return;
  }

  for (final phase in phases) {
    stdout.writeln(
      'phase ${phase.id}: $runsPerProfile runs per profile, ${phaseRules.startingPlayerLives} lives, ${phase.roundCount} rounds',
    );
    final reports = await Future.wait([for (final profile in selectedProfiles) Isolate.run(() => play(phase, profile))]);
    for (final (index, report) in reports.indexed) printReport(selectedProfiles[index], report, phase.roundCount);
  }
}

Report play(Phase phase, Profile profile) {
  var wins = 0;
  final lostRoundsPerRound = List.filled(phase.roundCount, 0);
  final gameOversPerRound = List.filled(phase.roundCount, 0);
  final reachedPerRound = List.filled(phase.roundCount, 0);

  for (var seed = 1; seed <= runsPerProfile; seed++) {
    final phaseRun = startPhase(phase, phaseRules, Random(seed));
    final random = Random(seed * 7919);
    while (phaseRun.status == PhaseStatus.inProgress) {
      final roundIndex = phaseRun.currentRoundNumber - 1;
      reachedPerRound[roundIndex] += 1;
      profile.shopping(phaseRun, random);
      profile.placement(phaseRun, random);
      final roundResult = fightRound(phaseRun)!;
      if (roundResult.isLost) lostRoundsPerRound[roundIndex] += 1;
      if (phaseRun.status == PhaseStatus.lost) gameOversPerRound[roundIndex] += 1;
    }
    if (phaseRun.status == PhaseStatus.won) wins += 1;
  }

  return (
    profileName: profile.name,
    wins: wins,
    lostRoundsPerRound: lostRoundsPerRound,
    gameOversPerRound: gameOversPerRound,
    reachedPerRound: reachedPerRound,
  );
}

void printReport(Profile profile, Report report, int roundCount) {
  String percentage(int count, int total) => total == 0 ? '   -  ' : '${(count / total * 100).toStringAsFixed(1)}%'.padLeft(6);
  final totalLostRounds = report.lostRoundsPerRound.fold(0, (sum, count) => sum + count);

  stdout.writeln('');
  stdout.writeln('== ${profile.name}: ${profile.description}');
  stdout.writeln(
    '   wins ${percentage(report.wins, runsPerProfile)}   rounds lost per run ${(totalLostRounds / runsPerProfile).toStringAsFixed(2)}',
  );
  stdout.writeln('   round   reached   lost the round   game over here');
  for (var roundIndex = 0; roundIndex < roundCount; roundIndex++) {
    final reached = report.reachedPerRound[roundIndex];
    stdout.writeln(
      '   ${'${roundIndex + 1}'.padLeft(5)}   ${percentage(reached, runsPerProfile)}   '
      '${percentage(report.lostRoundsPerRound[roundIndex], reached).padLeft(14)}   ${percentage(report.gameOversPerRound[roundIndex], runsPerProfile).padLeft(14)}',
    );
  }
}

int strengthOf(OwnedCharacter ownedCharacter) => ownedCharacter.character.rarity.coins * (1 << (ownedCharacter.stars - 1));

bool isFrontLiner(Character character) => character.role == Role.tank || character.role == Role.guard;

List<OwnedCharacter> strongestFirst(PhaseRun phaseRun) =>
    [...phaseRun.player.ownedCharacters]..sort((first, second) => strengthOf(second).compareTo(strengthOf(first)));

void placeOnField(PhaseRun phaseRun, List<OwnedCharacter> fielded, List<OwnedCharacter> benched, List<Position> positions) {
  final player = phaseRun.player;
  player.field.clear();
  player.bench.fillRange(0, player.bench.length, null);
  for (final (index, ownedCharacter) in fielded.indexed) player.field[positions[index]] = ownedCharacter;
  for (final (index, ownedCharacter) in benched.indexed) player.bench[index] = ownedCharacter;
}

List<Position> rowsFrontFirst(Board board) => [
  for (var row = board.rows ~/ 2; row < board.rows; row++)
    for (final column in [2, 1, 3, 0, 4]) Position(row: row, column: column),
];

void buyEverything(PhaseRun phaseRun, Random random) {
  for (var offerIndex = 0; offerIndex < phaseRun.player.shopOffers.length; offerIndex++) buyShopOffer(phaseRun, offerIndex);
}

void buyExperienceWhileRich(PhaseRun phaseRun, int coinsToKeep) {
  while (phaseRun.player.coins >= phaseRun.rules.shopRules.experiencePurchaseCostInCoins + coinsToKeep) {
    if (!buyExperience(phaseRun)) break;
  }
}

void buyEverythingThenExperience(PhaseRun phaseRun, Random random) {
  buyEverything(phaseRun, random);
  buyExperienceWhileRich(phaseRun, 6);
}

void experienceFirstThenEverything(PhaseRun phaseRun, Random random) {
  buyExperienceWhileRich(phaseRun, 0);
  buyEverything(phaseRun, random);
}

void rerollTwiceThenBuyEverything(PhaseRun phaseRun, Random random) {
  rerollShop(phaseRun);
  rerollShop(phaseRun);
  buyEverythingThenExperience(phaseRun, random);
}

void buyOnly(PhaseRun phaseRun, bool Function(Character character) wanted) {
  final player = phaseRun.player;
  for (var offerIndex = 0; offerIndex < player.shopOffers.length; offerIndex++) {
    final character = player.shopOffers[offerIndex];
    if (character != null && wanted(character)) buyShopOffer(phaseRun, offerIndex);
  }
  buyExperienceWhileRich(phaseRun, 6);
}

void buyOnlyCommons(PhaseRun phaseRun, Random random) => buyOnly(phaseRun, (character) => character.rarity == Rarity.common);
void buyOnlyFrontLiners(PhaseRun phaseRun, Random random) => buyOnly(phaseRun, isFrontLiner);
void buyOnlyBackLiners(PhaseRun phaseRun, Random random) => buyOnly(phaseRun, (character) => !isFrontLiner(character));

void buyHalfAtRandom(PhaseRun phaseRun, Random random) {
  for (var offerIndex = 0; offerIndex < phaseRun.player.shopOffers.length; offerIndex++) {
    if (random.nextBool()) buyShopOffer(phaseRun, offerIndex);
  }
}

void smartShopping(PhaseRun phaseRun, Random random) {
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
}

void strongestFrontFirst(PhaseRun phaseRun, Random random) {
  final ordered = strongestFirst(phaseRun);
  final fielded = ordered.take(phaseRun.player.level).toList();
  placeOnField(phaseRun, fielded, ordered.skip(phaseRun.player.level).toList(), rowsFrontFirst(phaseRun.rules.board));
}

void leaveTwoSlotsEmpty(PhaseRun phaseRun, Random random) {
  final ordered = strongestFirst(phaseRun);
  final fieldedCount = max(2, phaseRun.player.level - 2);
  placeOnField(phaseRun, ordered.take(fieldedCount).toList(), ordered.skip(fieldedCount).toList(), rowsFrontFirst(phaseRun.rules.board));
}

void backRowOnly(PhaseRun phaseRun, Random random) {
  final board = phaseRun.rules.board;
  final ordered = strongestFirst(phaseRun);
  final positions = [
    for (var row = board.rows - 1; row >= board.rows ~/ 2; row--)
      for (final column in [2, 1, 3, 0, 4]) Position(row: row, column: column),
  ];
  placeOnField(phaseRun, ordered.take(phaseRun.player.level).toList(), ordered.skip(phaseRun.player.level).toList(), positions);
}

void rolesPlacement(PhaseRun phaseRun, Random random) {
  final board = phaseRun.rules.board;
  final ordered = strongestFirst(phaseRun);
  final fielded = ordered.take(phaseRun.player.level).toList();
  final frontThenBack = [
    ...fielded.where((owned) => isFrontLiner(owned.character)),
    ...fielded.where((owned) => !isFrontLiner(owned.character)),
  ];
  final frontRow = board.rows ~/ 2;
  final positions = [
    for (final column in [2, 1, 3, 0, 4]) Position(row: frontRow, column: column),
    for (var row = frontRow + 2; row < board.rows; row++)
      for (final column in [2, 1, 3, 0, 4]) Position(row: row, column: column),
    for (final column in [2, 1, 3, 0, 4]) Position(row: frontRow + 1, column: column),
  ];
  placeOnField(phaseRun, frontThenBack, ordered.skip(phaseRun.player.level).toList(), positions);
}

void randomPlacement(PhaseRun phaseRun, Random random) {
  final shuffled = [...phaseRun.player.ownedCharacters]..shuffle(random);
  final positions = [...rowsFrontFirst(phaseRun.rules.board)]..shuffle(random);
  placeOnField(phaseRun, shuffled.take(phaseRun.player.level).toList(), shuffled.skip(phaseRun.player.level).toList(), positions);
}

EnemyWave waveFrom(List<(Character, int)> picks, int reward) {
  final ordered = [...picks.where((pick) => isFrontLiner(pick.$1)), ...picks.where((pick) => !isFrontLiner(pick.$1))];
  const columns = [2, 1, 3, 0, 4];
  final positions = [
    for (final row in [3, 2, 1, 0])
      for (final column in columns) Position(row: row, column: column),
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
