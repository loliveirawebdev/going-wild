import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/inventory/engines/basic_inventory_engine.dart';
import 'package:going_wild/domain/models/inventory/errors/inventory_is_full_error.dart';

import '../../../../helpers/inventory_helpers.dart';

void main() {
  const engine = BasicInventoryEngine<CharacterCopy>(capacity: 3);

  test('the empty inventory has the capacity of the engine', () {
    final inventory = engine.emptyInventory();
    expect(inventory.capacity, 3);
    expect(inventory.entries, isEmpty);
  });

  test('a new character goes to the first free slot', () {
    final inventory = engine.emptyInventory().createCopyWithEntryAt(0, characterCopyOf(cat)).createCopyWithEntryAt(2, characterCopyOf(dog));
    expect(engine.indexForNewEntry(inventory), 1);
  });

  test('a full inventory fails when asked for a slot for a new character', () {
    final inventory = engine
        .emptyInventory()
        .createCopyWithEntryAt(0, characterCopyOf(cat))
        .createCopyWithEntryAt(1, characterCopyOf(dog))
        .createCopyWithEntryAt(2, characterCopyOf(cow));
    expect(() => engine.indexForNewEntry(inventory), throwsA(isA<InventoryIsFullError>()));
  });
}
