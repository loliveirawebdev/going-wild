import 'dart:math';

import 'package:going_wild/domain/models/board/board.dart';
import 'package:going_wild/domain/models/board/board_side.dart';
import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/inventory/inventory_factory.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/roster/roster.dart';
import 'package:going_wild/simulation/bots/bot_evaluations.dart';

Board boardOf(MatchProgress matchProgress) => matchProgress.phase.engines.combatEngine.board;

List<int> teamRowsFrontFirst(MatchProgress matchProgress) {
  final board = boardOf(matchProgress);
  return [
    for (final (row, boardRow) in board.rows.indexed)
      if (boardRow.side != BoardSide.enemy) row,
  ];
}

List<Position> freeTeamPositionsOfRow(MatchProgress matchProgress, int row) {
  final board = boardOf(matchProgress);
  final enemyPositions = matchProgress.currentWave.enemies.map((enemy) => enemy.position).toSet();
  final rowCenter = (board.rows[row].cellCount - 1) / 2;

  final positions = board.allPositions
      .where((position) => position.row == row && board.isPositionOnTeamSide(position) && !enemyPositions.contains(position))
      .toList();

  return positions..sort((first, second) => (first.column - rowCenter).abs().compareTo((second.column - rowCenter).abs()));
}

List<Position> rowsFrontFirst(MatchProgress matchProgress) => [
  for (final row in teamRowsFrontFirst(matchProgress)) ...freeTeamPositionsOfRow(matchProgress, row),
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
  final positions = rowsFrontFirst(matchProgress);
  return arrangeStrongestFirst(matchProgress, positions, fieldedCount: teamSizeOf(matchProgress));
}

MatchProgress leaveTwoSlotsEmpty(MatchProgress matchProgress, Random randomGenerator) {
  final teamSize = teamSizeOf(matchProgress);
  final fieldedCount = min(teamSize, max(2, teamSize - 2));
  final positions = rowsFrontFirst(matchProgress);

  return arrangeStrongestFirst(matchProgress, positions, fieldedCount: fieldedCount);
}

MatchProgress backRowOnly(MatchProgress matchProgress, Random randomGenerator) {
  final positions = [
    for (final row in teamRowsFrontFirst(matchProgress).reversed) ...freeTeamPositionsOfRow(matchProgress, row),
  ];

  return arrangeStrongestFirst(matchProgress, positions, fieldedCount: teamSizeOf(matchProgress));
}

MatchProgress rolesPlacement(MatchProgress matchProgress, Random randomGenerator) {
  final teamSize = teamSizeOf(matchProgress);
  final ordered = strongestFirst(matchProgress);
  final fielded = ordered.take(teamSize).toList();
  final teamRows = teamRowsFrontFirst(matchProgress);

  final frontThenBack = [
    ...fielded.where((characterCopy) => isFrontLiner(characterCopy.character)),
    ...fielded.where((characterCopy) => !isFrontLiner(characterCopy.character)),
  ];

  final positions = [
    ...freeTeamPositionsOfRow(matchProgress, teamRows.first),
    for (final row in teamRows.skip(2)) ...freeTeamPositionsOfRow(matchProgress, row),
    ...freeTeamPositionsOfRow(matchProgress, teamRows[1]),
  ];

  return arrangeTeam(matchProgress, frontThenBack, ordered.skip(teamSize).toList(), positions);
}

MatchProgress randomPlacement(MatchProgress matchProgress, Random randomGenerator) {
  final teamSize = teamSizeOf(matchProgress);
  final shuffled = ownedCharacterCopiesOf(matchProgress)..shuffle(randomGenerator);
  final positions = rowsFrontFirst(matchProgress)..shuffle(randomGenerator);

  return arrangeTeam(matchProgress, shuffled.take(teamSize).toList(), shuffled.skip(teamSize).toList(), positions);
}
