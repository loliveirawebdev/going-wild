import 'package:going_wild/content/engines/inventory/basic_inventory_engine.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/inventory/inventory.dart';
import 'package:going_wild/domain/models/inventory/inventory_factory.dart';

CharacterCopy characterCopyOf(Character character, {int stars = 1}) => CharacterCopy(stars: stars, character: character);

Inventory<CharacterCopy> inventoryWith(List<CharacterCopy> inventoryCharacters, {int? capacity}) {
  var inventory = InventoryFactory.empty<CharacterCopy>(capacity: capacity ?? basicCharacterInventoryEngine.capacity);
  for (final (index, characterCopy) in inventoryCharacters.indexed) inventory = inventory.createCopyWithEntryAt(index, characterCopy);
  return inventory;
}
