import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/inventory/errors/inventory_index_out_of_range_error.dart';
import 'package:going_wild/domain/models/inventory/errors/inventory_is_full_error.dart';
import 'package:going_wild/domain/models/inventory/inventory_factory.dart';

import '../../../helpers/inventory_helpers.dart';

void main() {
  test('an empty inventory has every slot free', () {
    final inventory = InventoryFactory.empty<CharacterCopy>(capacity: 9);
    expect(inventory.capacity, 9);
    expect(inventory.isFull, isFalse);
    expect(inventory.entries, isEmpty);
    expect(inventory.firstFreeIndex, 0);
  });

  test('entries follow the slot order and skip the free slots', () {
    final inventory = inventoryWith([characterCopyOf(cat)]).createCopyWithEntryAt(3, characterCopyOf(dog));
    expect(inventory.entries.map((characterCopy) => characterCopy.character), [cat, dog]);
  });

  test('the first free index skips occupied slots and fails when the inventory is full', () {
    final inventory = inventoryWith([characterCopyOf(cat)], capacity: 2);
    expect(inventory.firstFreeIndex, 1);
    expect(() => inventory.createCopyWithEntryAt(1, characterCopyOf(dog)).firstFreeIndex, throwsA(isA<InventoryIsFullError>()));
  });

  test('a character can be placed and removed', () {
    final inventory = InventoryFactory.empty<CharacterCopy>(capacity: 5).createCopyWithEntryAt(4, characterCopyOf(cat));
    expect(inventory.entryAt(4)!.character, cat);
    expect(inventory.createCopyWithoutEntryAt(4).entryAt(4), isNull);
  });

  test('indexed entries keep the slot index of each character', () {
    final inventory = InventoryFactory.empty<CharacterCopy>(capacity: 5)
        .createCopyWithEntryAt(1, characterCopyOf(cat))
        .createCopyWithEntryAt(4, characterCopyOf(dog));
    expect(inventory.indexedEntries.map((indexedEntry) => indexedEntry.index), [1, 4]);
    expect(inventory.indexedEntries.map((indexedEntry) => indexedEntry.entry.character), [cat, dog]);
  });

  test('changing the inventory never changes the original', () {
    final inventory = inventoryWith([characterCopyOf(cat)]);
    final _ = inventory.createCopyWithoutEntryAt(0).createCopyWithEntryAt(1, characterCopyOf(dog));
    expect(inventory.entries.map((characterCopy) => characterCopy.character), [cat]);
  });

  test('the capacity is the number of slots and the inventory is full when no slot is free', () {
    final inventory = inventoryWith([characterCopyOf(cat)], capacity: 2);
    expect(inventory.capacity, 2);
    expect(inventory.isFull, isFalse);
    expect(inventory.createCopyWithEntryAt(1, characterCopyOf(dog)).isFull, isTrue);
  });

  test('reading, placing or removing outside the inventory fails', () {
    final inventory = InventoryFactory.empty<CharacterCopy>(capacity: 3);
    expect(() => inventory.entryAt(3), throwsA(isA<InventoryIndexOutOfRangeError>()));
    expect(() => inventory.createCopyWithEntryAt(-1, characterCopyOf(cat)), throwsA(isA<InventoryIndexOutOfRangeError>()));
    expect(() => inventory.createCopyWithoutEntryAt(3), throwsA(isA<InventoryIndexOutOfRangeError>()));
  });
}
