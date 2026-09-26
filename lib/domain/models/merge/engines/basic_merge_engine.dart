import 'dart:math';

import '../../character/character_copy.dart';
import '../../inventory/engines/inventory_engine.dart';
import '../../roster/roster.dart';
import '../../roster/roster_slot.dart';
import '../merge.dart';
import 'merge_engine.dart';

typedef _MergeCandidate = ({RosterSlot? slot, CharacterCopy characterCopy});

class BasicMergeEngine extends MergeEngine {
  const BasicMergeEngine({required this.copiesPerMerge});

  @override
  final int copiesPerMerge;

  @override
  int copiesInside(int stars) => pow(copiesPerMerge, stars - 1).toInt();

  @override
  Roster? mergeWithNewCopy(
    Roster roster,
    CharacterCopy newCharacterCopy, {
    required int maxStars,
    required InventoryEngine<CharacterCopy> inventoryEngine,
  }) {
    final newCopyCandidate = (slot: null, characterCopy: newCharacterCopy);
    final candidatesWithNewCopy = [..._candidatesOf(roster), newCopyCandidate];
    final newCopyIndex = candidatesWithNewCopy.length - 1;

    final merge = findMerge(_characterCopiesOf(candidatesWithNewCopy), maxStars: maxStars);
    final completesMerge = merge != null && merge.copyIndexes.contains(newCopyIndex);

    if (!completesMerge) {
      if (roster.inventory.isFull) return null;

      final newEntryIndex = inventoryEngine.indexForNewEntry(roster.inventory);
      return roster.createCopyWithEntryAt(InventorySlot(index: newEntryIndex), newCharacterCopy);
    }

    final mergedRoster = _applyMerge(roster, candidatesWithNewCopy, merge, inventoryEngine);
    return _mergeUntilNothingLeft(mergedRoster, maxStars, inventoryEngine);
  }

  Merge? findMerge(List<CharacterCopy> characterCopies, {required int maxStars}) {
    for (final characterCopy in characterCopies) {
      if (characterCopy.stars >= maxStars) continue;

      final copyIndexes = [
        for (final (index, otherCharacterCopy) in characterCopies.indexed)
          if (otherCharacterCopy.character == characterCopy.character && otherCharacterCopy.stars == characterCopy.stars) index,
      ].take(copiesPerMerge).toList();

      if (copyIndexes.length < copiesPerMerge) continue;
      return Merge(copyIndexes: copyIndexes, newStars: characterCopy.stars + 1);
    }

    return null;
  }

  Roster _mergeUntilNothingLeft(Roster roster, int maxStars, InventoryEngine<CharacterCopy> inventoryEngine) {
    var mergedRoster = roster;

    while (true) {
      final candidates = _candidatesOf(mergedRoster);
      final merge = findMerge(_characterCopiesOf(candidates), maxStars: maxStars);
      if (merge == null) return mergedRoster;

      mergedRoster = _applyMerge(mergedRoster, candidates, merge, inventoryEngine);
    }
  }

  Roster _applyMerge(Roster roster, List<_MergeCandidate> candidates, Merge merge, InventoryEngine<CharacterCopy> inventoryEngine) {
    var rosterWithoutCopies = roster;

    for (final copyIndex in merge.copyIndexes) {
      final copySlot = candidates[copyIndex].slot;
      if (copySlot != null) rosterWithoutCopies = rosterWithoutCopies.createCopyWithoutEntryAt(copySlot);
    }

    final firstCopy = candidates[merge.copyIndexes.first];
    final mergedCharacterCopy = CharacterCopy(stars: merge.newStars, character: firstCopy.characterCopy.character);
    final mergedSlot = firstCopy.slot ?? InventorySlot(index: inventoryEngine.indexForNewEntry(rosterWithoutCopies.inventory));

    return rosterWithoutCopies.createCopyWithEntryAt(mergedSlot, mergedCharacterCopy);
  }

  List<_MergeCandidate> _candidatesOf(Roster roster) => [
    for (final entry in roster.entries) (slot: entry.slot, characterCopy: entry.characterCopy),
  ];

  List<CharacterCopy> _characterCopiesOf(List<_MergeCandidate> candidates) => [
    for (final candidate in candidates) candidate.characterCopy,
  ];
}
