import 'dart:math';

import 'package:going_wild/domain/models/board/board.dart';
import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/inventory/inventory_factory.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/roster/roster.dart';
import 'package:going_wild/simulation/bots/bot_evaluations.dart';

const frontToBackColumns = [2, 1, 3, 0, 4];

Board boardOf(MatchProgress matchProgress) => matchProgress.phase.engines.combatEngine.board;

List<Position> rowsFrontFirst(Board board) => [
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

MatchProgress strongestFrontFirst(MatchProgress matchProgress, Random randomGenerator) {
  final positions = rowsFrontFirst(boardOf(matchProgress));
  return arrangeStrongestFirst(matchProgress, positions, fieldedCount: teamSizeOf(matchProgress));
}

MatchProgress leaveTwoSlotsEmpty(MatchProgress matchProgress, Random randomGenerator) {
  final teamSize = teamSizeOf(matchProgress);
  final fieldedCount = min(teamSize, max(2, teamSize - 2));
  final positions = rowsFrontFirst(boardOf(matchProgress));

  return arrangeStrongestFirst(matchProgress, positions, fieldedCount: fieldedCount);
}

MatchProgress backRowOnly(MatchProgress matchProgress, Random randomGenerator) {
  final board = boardOf(matchProgress);

  final positions = [
    for (var row = board.rows - 1; row >= board.rows ~/ 2; row--)
      for (final column in frontToBackColumns) Position(row: row, column: column),
  ];

  return arrangeStrongestFirst(matchProgress, positions, fieldedCount: teamSizeOf(matchProgress));
}

MatchProgress rolesPlacement(MatchProgress matchProgress, Random randomGenerator) {
  final board = boardOf(matchProgress);
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

MatchProgress randomPlacement(MatchProgress matchProgress, Random randomGenerator) {
  final teamSize = teamSizeOf(matchProgress);
  final shuffled = ownedCharacterCopiesOf(matchProgress)..shuffle(randomGenerator);
  final positions = rowsFrontFirst(boardOf(matchProgress))..shuffle(randomGenerator);

  return arrangeTeam(matchProgress, shuffled.take(teamSize).toList(), shuffled.skip(teamSize).toList(), positions);
}
