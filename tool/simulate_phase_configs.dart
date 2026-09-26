import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:going_wild/content/board.dart';
import 'package:going_wild/content/engines/basic_phase_engines.dart';
import 'package:going_wild/content/engines/economy/basic_economy_engine.dart';
import 'package:going_wild/content/engines/level/basic_level_engine.dart';
import 'package:going_wild/content/engines/merge/basic_merge_engine.dart';
import 'package:going_wild/content/engines/player/basic_player_engine.dart';
import 'package:going_wild/content/phase/phases.dart';
import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/character/rarity.dart';
import 'package:going_wild/domain/models/character/role.dart';
import 'package:going_wild/domain/models/inventory/errors/inventory_is_full_error.dart';
import 'package:going_wild/domain/models/inventory/inventory_factory.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/phase/phase.dart';
import 'package:going_wild/domain/models/phase/phase_id.dart';
import 'package:going_wild/domain/models/phase/phase_status.dart';
import 'package:going_wild/domain/models/phase/phase_wave.dart';
import 'package:going_wild/domain/models/roster/roster.dart';
import 'package:going_wild/domain/use_cases/level/buy_experience.dart';
import 'package:going_wild/domain/use_cases/lineup/sell_from_inventory.dart';
import 'package:going_wild/domain/use_cases/round/fight_round.dart';
import 'package:going_wild/domain/use_cases/round/start_match.dart';
import 'package:going_wild/domain/use_cases/shop/buy_shop_offer.dart';
import 'package:going_wild/domain/use_cases/shop/reroll_shop.dart';

const runsPerProfile = 1000;
const frontToBackColumns = [2, 1, 3, 0, 4];

const startMatch = StartMatch();
const fightRound = FightRound();
const rerollShop = RerollShop();
const buyShopOffer = BuyShopOffer();
const buyExperience = BuyExperience();
const sellFromInventory = SellFromInventory();

typedef ShoppingStrategy = MatchProgress Function(MatchProgress matchProgress, Random random);
typedef PlacementStrategy = MatchProgress Function(MatchProgress matchProgress, Random random);
typedef Profile = ({String name, String description, ShoppingStrategy shopping, PlacementStrategy placement});
typedef Report = ({int wins, String profileName, List<int> reachedPerRound, List<int> gameOversPerRound, List<int> lostRoundsPerRound});
typedef NamedPhase = ({String name, Phase phase});
typedef IndexedCharacterCopy = ({int index, CharacterCopy characterCopy});

final profiles = <Profile>[
  (
    name: 'smart',
    shopping: smartShopping,
    placement: rolesPlacement,
    description: 'compra merges e caros, vende fraco, XP quando sobra boneco, tanque na frente',
  ),
  (
    shopping: smartShopping,
    placement: randomPlacement,
    name: 'smart, random placement',
    description: 'compra como o smart, mas posiciona ao acaso',
  ),
  (
    name: 'greedy',
    placement: strongestFrontFirst,
    shopping: buyEverythingThenExperience,
    description: 'compra tudo, XP quando sobra, mais fortes na frente sem olhar papel',
  ),
  (
    placement: backRowOnly,
    name: 'greedy, back row',
    shopping: buyEverythingThenExperience,
    description: 'compra tudo, todo mundo na ultima fileira',
  ),
  (name: 'hoarder', shopping: buyEverything, placement: rolesPlacement, description: 'compra tudo, nunca compra XP'),
  (
    name: 'leveler',
    placement: rolesPlacement,
    shopping: experienceFirstThenEverything,
    description: 'toda moeda em XP primeiro, compra com o que sobra',
  ),
  (
    name: 'reroller',
    placement: rolesPlacement,
    shopping: rerollTwiceThenBuyEverything,
    description: 'dois rerolls por round antes de comprar tudo',
  ),
  (name: 'commons only', shopping: buyOnlyCommons, placement: rolesPlacement, description: 'so compra personagem de 1 moeda'),
  (name: 'front liners only', shopping: buyOnlyFrontLiners, placement: rolesPlacement, description: 'so compra tanque e guarda'),
  (name: 'damage only', shopping: buyOnlyBackLiners, placement: rolesPlacement, description: 'so compra dano e suporte'),
  (
    name: 'weak board',
    placement: leaveTwoSlotsEmpty,
    shopping: buyEverythingThenExperience,
    description: 'compra tudo, deixa duas vagas do campo vazias',
  ),
  (
    name: 'random',
    shopping: buyHalfAtRandom,
    placement: randomPlacement,
    description: 'compra metade das ofertas ao acaso, nunca XP, posiciona ao acaso',
  ),
];

final candidatePhases = <NamedPhase>[];

Future<void> main(List<String> arguments) async {
  final onlyIndex = arguments.indexOf('--only');
  final selectedProfiles = onlyIndex == -1
      ? profiles
      : profiles.where((profile) => arguments[onlyIndex + 1].split(',').contains(profile.name)).toList();
  final phases = <NamedPhase>[for (final phase in allPhases) (name: phase.id.value, phase: phase), ...candidatePhases];

  final wavesIndex = arguments.indexOf('--waves');
  if (wavesIndex != -1) {
    final phase = phases.firstWhere((namedPhase) => namedPhase.name == arguments[wavesIndex + 1]).phase;
    printWaves(phase, printDartSource: arguments.contains('--dart'));
    return;
  }

  for (final (:name, :phase) in phases) {
    stdout.writeln('phase $name: $runsPerProfile runs per profile, ${basicPlayerEngine.startingLives} lives, ${phase.roundCount} rounds');

    final reports = await Future.wait([for (final profile in selectedProfiles) Isolate.run(() => play(phase, profile))]);
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

Report play(Phase phase, Profile profile) {
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

      final shoppedMatchProgress = profile.shopping(matchProgress, botRandom);
      final arrangedMatchProgress = profile.placement(shoppedMatchProgress, botRandom);
      final fought = fightRound(arrangedMatchProgress);
      matchProgress = fought.matchProgress;

      if (fought.combatResult.isLost) lostRoundsPerRound[roundIndex] += 1;
      if (matchProgress.status == PhaseStatus.lost) gameOversPerRound[roundIndex] += 1;
    }

    if (matchProgress.status == PhaseStatus.won) wins += 1;
  }

  return (
    wins: wins,
    profileName: profile.name,
    reachedPerRound: reachedPerRound,
    gameOversPerRound: gameOversPerRound,
    lostRoundsPerRound: lostRoundsPerRound,
  );
}

void printReport(Profile profile, Report report, int roundCount) {
  String percentage(int count, int total) => total == 0 ? '   -  ' : '${(count / total * 100).toStringAsFixed(1)}%'.padLeft(6);
  final totalLostRounds = report.lostRoundsPerRound.fold(0, (sum, count) => sum + count);
  final lostRoundsPerRun = (totalLostRounds / runsPerProfile).toStringAsFixed(2);

  stdout.writeln('');
  stdout.writeln('== ${profile.name}: ${profile.description}');
  stdout.writeln('   wins ${percentage(report.wins, runsPerProfile)}   rounds lost per run $lostRoundsPerRun');
  stdout.writeln('   round   reached   lost the round   game over here');

  for (var roundIndex = 0; roundIndex < roundCount; roundIndex++) {
    final reached = report.reachedPerRound[roundIndex];
    final lostTheRound = percentage(report.lostRoundsPerRound[roundIndex], reached).padLeft(14);
    final gameOverHere = percentage(report.gameOversPerRound[roundIndex], runsPerProfile).padLeft(14);

    stdout.writeln('   ${'${roundIndex + 1}'.padLeft(5)}   ${percentage(reached, runsPerProfile)}   $lostTheRound   $gameOverHere');
  }
}

int teamSizeOf(MatchProgress matchProgress) => matchProgress.playerLevelProgress.level.teamSize;

int priceOf(Character character) => basicEconomyEngine.priceOf(character);

int strengthOf(CharacterCopy characterCopy) => priceOf(characterCopy.character) * basicMergeEngine.copiesInside(characterCopy.stars);

bool isFrontLiner(Character character) => character.role == Role.tank || character.role == Role.guard;

List<CharacterCopy> ownedCharacterCopiesOf(MatchProgress matchProgress) => matchProgress.playerRoster.characterCopies;

List<CharacterCopy> strongestFirst(MatchProgress matchProgress) =>
    ownedCharacterCopiesOf(matchProgress)..sort((first, second) => strengthOf(second).compareTo(strengthOf(first)));

List<Position> rowsFrontFirst() => [
  for (var row = board.rows ~/ 2; row < board.rows; row++)
    for (final column in frontToBackColumns) Position(row: row, column: column),
];

MatchProgress arrangeTeam(MatchProgress matchProgress, List<CharacterCopy> fielded, List<CharacterCopy> benched, List<Position> positions) {
  var inventory = InventoryFactory.empty<CharacterCopy>(capacity: matchProgress.playerRoster.inventory.capacity);
  for (final (index, characterCopy) in benched.indexed) inventory = inventory.createCopyWithEntryAt(index, characterCopy);

  final placements = [
    for (final (index, characterCopy) in fielded.indexed) Placement(position: positions[index], characterCopy: characterCopy),
  ];

  return matchProgress.createCopyWith(
    playerRoster: Roster(inventory: inventory, placements: placements),
  );
}

MatchProgress arrangeStrongestFirst(MatchProgress matchProgress, List<Position> positions, {required int fieldedCount}) {
  final ordered = strongestFirst(matchProgress);
  final benchCapacity = matchProgress.playerRoster.inventory.capacity;
  final fieldedCountWithinBench = max(fieldedCount, ordered.length - benchCapacity);
  final fielded = ordered.take(fieldedCountWithinBench).toList();

  return arrangeTeam(matchProgress, fielded, ordered.skip(fielded.length).toList(), positions);
}

MatchProgress? tryBuying(MatchProgress matchProgress, int offerIndex) {
  final offeredCharacter = matchProgress.shop.offers[offerIndex];
  if (offeredCharacter == null || !matchProgress.player.canAfford(priceOf(offeredCharacter))) return null;

  try {
    return buyShopOffer(matchProgress, offerIndex: offerIndex);
  } on InventoryIsFullError {
    return null;
  }
}

bool canBuyExperience(MatchProgress matchProgress, {int coinsToKeep = 0}) {
  final experienceCost = basicEconomyEngine.experiencePurchaseCostInCoins;
  final isMaxLevel = basicLevelEngine.isMaxLevel(matchProgress.playerLevelProgress.level);

  return !isMaxLevel && matchProgress.player.canAfford(experienceCost + coinsToKeep);
}

MatchProgress buyEverything(MatchProgress matchProgress, Random random) {
  var shoppingMatchProgress = matchProgress;

  for (var offerIndex = 0; offerIndex < shoppingMatchProgress.shop.offers.length; offerIndex++) {
    shoppingMatchProgress = tryBuying(shoppingMatchProgress, offerIndex) ?? shoppingMatchProgress;
  }

  return shoppingMatchProgress;
}

MatchProgress buyExperienceWhileRich(MatchProgress matchProgress, {required int coinsToKeep}) {
  var levelingMatchProgress = matchProgress;

  while (canBuyExperience(levelingMatchProgress, coinsToKeep: coinsToKeep)) {
    levelingMatchProgress = buyExperience(levelingMatchProgress);
  }

  return levelingMatchProgress;
}

MatchProgress buyEverythingThenExperience(MatchProgress matchProgress, Random random) {
  final boughtMatchProgress = buyEverything(matchProgress, random);
  return buyExperienceWhileRich(boughtMatchProgress, coinsToKeep: 6);
}

MatchProgress experienceFirstThenEverything(MatchProgress matchProgress, Random random) {
  final leveledMatchProgress = buyExperienceWhileRich(matchProgress, coinsToKeep: 0);
  return buyEverything(leveledMatchProgress, random);
}

MatchProgress rerollTwiceThenBuyEverything(MatchProgress matchProgress, Random random) {
  var rerolledMatchProgress = matchProgress;

  for (var reroll = 0; reroll < 2; reroll++) {
    if (!rerolledMatchProgress.player.canAfford(basicEconomyEngine.rerollCostInCoins)) break;

    rerolledMatchProgress = rerollShop(rerolledMatchProgress);
  }

  return buyEverythingThenExperience(rerolledMatchProgress, random);
}

MatchProgress buyOnly(MatchProgress matchProgress, bool Function(Character character) isWanted) {
  var shoppingMatchProgress = matchProgress;

  for (var offerIndex = 0; offerIndex < shoppingMatchProgress.shop.offers.length; offerIndex++) {
    final offeredCharacter = shoppingMatchProgress.shop.offers[offerIndex];
    if (offeredCharacter == null || !isWanted(offeredCharacter)) continue;

    shoppingMatchProgress = tryBuying(shoppingMatchProgress, offerIndex) ?? shoppingMatchProgress;
  }

  return buyExperienceWhileRich(shoppingMatchProgress, coinsToKeep: 6);
}

MatchProgress buyOnlyCommons(MatchProgress matchProgress, Random random) =>
    buyOnly(matchProgress, (character) => character.rarity == Rarity.common);

MatchProgress buyOnlyFrontLiners(MatchProgress matchProgress, Random random) => buyOnly(matchProgress, isFrontLiner);

MatchProgress buyOnlyBackLiners(MatchProgress matchProgress, Random random) =>
    buyOnly(matchProgress, (character) => !isFrontLiner(character));

MatchProgress buyHalfAtRandom(MatchProgress matchProgress, Random random) {
  var shoppingMatchProgress = matchProgress;

  for (var offerIndex = 0; offerIndex < shoppingMatchProgress.shop.offers.length; offerIndex++) {
    if (!random.nextBool()) continue;

    shoppingMatchProgress = tryBuying(shoppingMatchProgress, offerIndex) ?? shoppingMatchProgress;
  }

  return shoppingMatchProgress;
}

MatchProgress smartShopping(MatchProgress matchProgress, Random random) {
  var shoppingMatchProgress = matchProgress;
  final offers = matchProgress.shop.offers;

  bool completesAMerge(Character character) {
    final oneStarCopies = ownedCharacterCopiesOf(shoppingMatchProgress).where(
      (characterCopy) => characterCopy.character == character && characterCopy.stars == 1,
    );

    return oneStarCopies.length >= basicMergeEngine.copiesPerMerge - 1;
  }

  final offerIndexes = [
    for (final (index, offeredCharacter) in offers.indexed)
      if (offeredCharacter != null) index,
  ];

  offerIndexes.sort((firstIndex, secondIndex) {
    final firstCharacter = offers[firstIndex]!;
    final secondCharacter = offers[secondIndex]!;
    final mergeOrder = (completesAMerge(secondCharacter) ? 1 : 0).compareTo(completesAMerge(firstCharacter) ? 1 : 0);
    if (mergeOrder != 0) return mergeOrder;

    return priceOf(secondCharacter).compareTo(priceOf(firstCharacter));
  });

  for (final offerIndex in offerIndexes) {
    final offeredCharacter = offers[offerIndex]!;
    if (!shoppingMatchProgress.player.canAfford(priceOf(offeredCharacter))) continue;

    final boughtMatchProgress = tryBuying(shoppingMatchProgress, offerIndex);

    if (boughtMatchProgress != null) {
      shoppingMatchProgress = boughtMatchProgress;
      continue;
    }

    final weakestBenched = weakestBenchedOf(shoppingMatchProgress);
    if (weakestBenched == null || strengthOf(weakestBenched.characterCopy) >= priceOf(offeredCharacter)) continue;

    final soldMatchProgress = sellFromInventory(shoppingMatchProgress, inventoryIndex: weakestBenched.index);
    shoppingMatchProgress = tryBuying(soldMatchProgress, offerIndex) ?? soldMatchProgress;
  }

  while (ownedCharacterCopiesOf(shoppingMatchProgress).length > teamSizeOf(shoppingMatchProgress) &&
      canBuyExperience(shoppingMatchProgress)) {
    shoppingMatchProgress = buyExperience(shoppingMatchProgress);
  }

  return shoppingMatchProgress;
}

IndexedCharacterCopy? weakestBenchedOf(MatchProgress matchProgress) {
  IndexedCharacterCopy? weakestBenched;

  for (final indexedEntry in matchProgress.playerRoster.inventory.indexedEntries) {
    final isWeaker = weakestBenched == null || strengthOf(indexedEntry.entry) < strengthOf(weakestBenched.characterCopy);
    if (isWeaker) weakestBenched = (index: indexedEntry.index, characterCopy: indexedEntry.entry);
  }

  return weakestBenched;
}

MatchProgress strongestFrontFirst(MatchProgress matchProgress, Random random) {
  return arrangeStrongestFirst(matchProgress, rowsFrontFirst(), fieldedCount: teamSizeOf(matchProgress));
}

MatchProgress leaveTwoSlotsEmpty(MatchProgress matchProgress, Random random) {
  final teamSize = teamSizeOf(matchProgress);
  final fieldedCount = min(teamSize, max(2, teamSize - 2));

  return arrangeStrongestFirst(matchProgress, rowsFrontFirst(), fieldedCount: fieldedCount);
}

MatchProgress backRowOnly(MatchProgress matchProgress, Random random) {
  final positions = [
    for (var row = board.rows - 1; row >= board.rows ~/ 2; row--)
      for (final column in frontToBackColumns) Position(row: row, column: column),
  ];

  return arrangeStrongestFirst(matchProgress, positions, fieldedCount: teamSizeOf(matchProgress));
}

MatchProgress rolesPlacement(MatchProgress matchProgress, Random random) {
  final teamSize = teamSizeOf(matchProgress);
  final ordered = strongestFirst(matchProgress);
  final fielded = ordered.take(teamSize).toList();
  final frontRow = board.rows ~/ 2;

  final frontThenBack = [
    ...fielded.where((characterCopy) => isFrontLiner(characterCopy.character)),
    ...fielded.where((characterCopy) => !isFrontLiner(characterCopy.character)),
  ];

  final positions = [
    for (final column in frontToBackColumns) Position(row: frontRow, column: column),
    for (var row = frontRow + 2; row < board.rows; row++)
      for (final column in frontToBackColumns) Position(row: row, column: column),
    for (final column in frontToBackColumns) Position(column: column, row: frontRow + 1),
  ];

  return arrangeTeam(matchProgress, frontThenBack, ordered.skip(teamSize).toList(), positions);
}

MatchProgress randomPlacement(MatchProgress matchProgress, Random random) {
  final teamSize = teamSizeOf(matchProgress);
  final shuffled = ownedCharacterCopiesOf(matchProgress)..shuffle(random);
  final positions = rowsFrontFirst()..shuffle(random);

  return arrangeTeam(matchProgress, shuffled.take(teamSize).toList(), shuffled.skip(teamSize).toList(), positions);
}

PhaseWave waveFrom(List<CharacterCopy> enemyCopies, int coinsReward) {
  final ordered = [
    ...enemyCopies.where((characterCopy) => isFrontLiner(characterCopy.character)),
    ...enemyCopies.where((characterCopy) => !isFrontLiner(characterCopy.character)),
  ];

  final positions = [
    for (final row in [3, 2, 1, 0])
      for (final column in frontToBackColumns) Position(row: row, column: column),
  ];

  return PhaseWave(
    coinsReward: coinsReward,
    enemies: [for (final (index, characterCopy) in ordered.indexed) Placement(position: positions[index], characterCopy: characterCopy)],
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
