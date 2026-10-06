import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/roster/roster.dart';
import 'package:going_wild/domain/models/roster/roster_entry.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';

List<RosterSlot> summonedSlotsBetween({required Roster previous, required Roster current}) {
  final previousBoardCopies = [for (final placement in previous.placements) placement.characterCopy];
  final previousBenchCopies = [for (final indexedEntry in previous.inventory.indexedEntries) indexedEntry.entry];

  return [
    for (final entry in current.entries)
      if (_isSummoned(entry, previousBoardCopies: previousBoardCopies, previousBenchCopies: previousBenchCopies)) entry.slot,
  ];
}

bool _isSummoned(
  RosterEntry entry, {
  required List<CharacterCopy> previousBoardCopies,
  required List<CharacterCopy> previousBenchCopies,
}) {
  final characterCopy = entry.characterCopy;
  final wasOnBoard = previousBoardCopies.any((previousCopy) => identical(previousCopy, characterCopy));
  final wasOnBench = previousBenchCopies.any((previousCopy) => identical(previousCopy, characterCopy));

  final hasChangedSides = switch (entry.slot) {
    BoardSlot() => wasOnBench,
    InventorySlot() => wasOnBoard,
  };
  final hasGainedStar = !wasOnBoard && !wasOnBench && characterCopy.stars > 1;

  return hasChangedSides || hasGainedStar;
}
