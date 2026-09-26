import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/roster/roster.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';

import '../../../helpers/inventory_helpers.dart';
import '../../../helpers/use_case_helpers.dart';

void main() {
  final roster = Roster(
    inventory: inventoryWith([characterCopyOf(dog)], capacity: 3),
    placements: [Placement(position: at(6, 2), characterCopy: characterCopyOf(cat))],
  );

  test('entries list the board first and then the inventory, each with its slot', () {
    final entries = roster.entries;

    expect(entries.map((entry) => entry.characterCopy.character), [cat, dog]);
    expect((entries.first.slot as BoardSlot).position, at(6, 2));
    expect((entries.last.slot as InventorySlot).index, 0);
  });

  test('character copies are every copy the player owns', () {
    expect(roster.characterCopies.map((characterCopy) => characterCopy.character), [cat, dog]);
  });

  test('an entry can be removed from either slot kind', () {
    final withoutBoardEntry = roster.createCopyWithoutEntryAt(BoardSlot(position: at(6, 2)));
    final withoutInventoryEntry = roster.createCopyWithoutEntryAt(const InventorySlot(index: 0));

    expect(withoutBoardEntry.placements, isEmpty);
    expect(withoutInventoryEntry.inventory.entries, isEmpty);
  });

  test('an entry can be placed in either slot kind', () {
    final withBoardEntry = roster.createCopyWithEntryAt(BoardSlot(position: at(7, 0)), characterCopyOf(cow));
    final withInventoryEntry = roster.createCopyWithEntryAt(const InventorySlot(index: 2), characterCopyOf(cow));

    expect(withBoardEntry.placements.last.characterCopy.character, cow);
    expect(withInventoryEntry.inventory.entryAt(2)!.character, cow);
  });

  test('changing the roster never changes the original', () {
    final _ = roster.createCopyWithoutEntryAt(const InventorySlot(index: 0));

    expect(roster.characterCopies, hasLength(2));
  });
}
