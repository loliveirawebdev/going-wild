import 'dart:io';
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
import 'package:going_wild/domain/models/combat/board/position.dart';
import 'package:going_wild/domain/models/phase/phase_rules.dart';
import 'package:going_wild/domain/models/phase/phase_run.dart';
import 'package:going_wild/domain/models/phase/phase_status.dart';
import 'package:going_wild/domain/models/shop/shop_rules.dart';
import 'package:going_wild/domain/use_cases/phase/fight_round.dart';
import 'package:going_wild/domain/use_cases/phase/start_phase.dart';
import 'package:going_wild/domain/use_cases/player/buy_experience.dart';
import 'package:going_wild/domain/use_cases/shop/buy_shop_offer.dart';

const seedCount = 50;
const coinsKeptAfterBuyingExperience = 6;

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
  ),
);

void main() {
  final livesTakenPerRound = List.filled(backyard.roundCount, 0);
  final roundsReachedPerRound = List.filled(backyard.roundCount, 0);
  final lossesPerRound = List.filled(backyard.roundCount, 0);
  final levelPerRound = List.filled(backyard.roundCount, 0);
  var phasesWon = 0;

  for (var seed = 1; seed <= seedCount; seed++) {
    final phaseRun = startPhase(backyard, phaseRules, Random(seed));
    while (phaseRun.status == PhaseStatus.inProgress) {
      final roundIndex = phaseRun.currentRoundNumber - 1;
      shopGreedily(phaseRun);
      roundsReachedPerRound[roundIndex] += 1;
      levelPerRound[roundIndex] += phaseRun.player.level;
      arrangeStrongestOnField(phaseRun);
      final roundResult = fightRound(phaseRun)!;
      livesTakenPerRound[roundIndex] += roundResult.livesTaken;
      if (phaseRun.status == PhaseStatus.lost) lossesPerRound[roundIndex] += 1;
    }
    if (phaseRun.status == PhaseStatus.won) phasesWon += 1;
  }

  stdout.writeln('greedy bot, $seedCount seeds, ${phaseRules.startingPlayerLives} lives, ${backyard.roundCount} rounds');
  stdout.writeln('phases won: $phasesWon/$seedCount');
  stdout.writeln('round  reached  avg level  lives taken per run  phase lost here');
  for (var roundIndex = 0; roundIndex < backyard.roundCount; roundIndex++) {
    final reached = roundsReachedPerRound[roundIndex];
    final averageLevel = reached == 0 ? 0 : levelPerRound[roundIndex] / reached;
    final averageLivesTaken = reached == 0 ? 0 : livesTakenPerRound[roundIndex] / reached;
    stdout.writeln(
      '${'${roundIndex + 1}'.padLeft(5)}  ${'$reached'.padLeft(7)}  ${averageLevel.toStringAsFixed(1).padLeft(9)}  '
      '${averageLivesTaken.toStringAsFixed(2).padLeft(20)}  ${'${lossesPerRound[roundIndex]}'.padLeft(15)}',
    );
  }
}

void shopGreedily(PhaseRun phaseRun) {
  final shopRules = phaseRun.rules.shopRules;
  for (var offerIndex = 0; offerIndex < phaseRun.player.shopOffers.length; offerIndex++) buyShopOffer(phaseRun, offerIndex);
  while (phaseRun.player.coins >= shopRules.experiencePurchaseCostInCoins + coinsKeptAfterBuyingExperience) {
    buyExperience(phaseRun);
  }
}

void arrangeStrongestOnField(PhaseRun phaseRun) {
  final player = phaseRun.player;
  final board = phaseRun.rules.board;

  final teamPositions = [
    for (var row = board.rows - 2; row >= board.rows ~/ 2; row--)
      for (var column = 0; column < board.columns; column++) Position(row: row, column: column),
    for (var column = 0; column < board.columns; column++) Position(row: board.rows - 1, column: column),
  ];

  int strengthOf(int coins, int stars) => coins * (1 << (stars - 1));

  final strongestFirst = [...player.ownedCharacters]
    ..sort(
      (first, second) =>
          strengthOf(second.character.rarity.coins, second.stars).compareTo(strengthOf(first.character.rarity.coins, first.stars)),
    );

  player.field.clear();
  player.bench.fillRange(0, player.bench.length, null);

  for (final (index, ownedCharacter) in strongestFirst.indexed) {
    if (index < player.level) {
      player.field[teamPositions[index]] = ownedCharacter;
      continue;
    }
    player.bench[index - player.level] = ownedCharacter;
  }
}
