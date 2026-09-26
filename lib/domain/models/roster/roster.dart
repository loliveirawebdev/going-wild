import 'package:meta/meta.dart';

import '../board/placement.dart';
import '../board/placement_list.dart';
import '../character/character_copy.dart';
import '../inventory/inventory.dart';
import 'roster_entry.dart';
import 'roster_slot.dart';

class Roster {
  const Roster({required this.inventory, required this.placements});

  final List<Placement> placements;
  final Inventory<CharacterCopy> inventory;

  List<RosterEntry> get entries => [
    for (final placement in placements)
      RosterEntry(
        characterCopy: placement.characterCopy,
        slot: BoardSlot(position: placement.position),
      ),

    for (final indexedEntry in inventory.indexedEntries)
      RosterEntry(
        characterCopy: indexedEntry.entry,
        slot: InventorySlot(index: indexedEntry.index),
      ),
  ];

  List<CharacterCopy> get characterCopies => [for (final entry in entries) entry.characterCopy];

  @useResult
  Roster createCopyWith({List<Placement>? placements, Inventory<CharacterCopy>? inventory}) => Roster(
    inventory: inventory ?? this.inventory,
    placements: placements ?? this.placements,
  );

  @useResult
  Roster createCopyWithoutEntryAt(RosterSlot slot) => switch (slot) {
    InventorySlot(:final index) => createCopyWith(inventory: inventory.createCopyWithoutEntryAt(index)),
    BoardSlot(:final position) => createCopyWith(placements: placements.createCopyWithoutPlacementAt(position)),
  };

  @useResult
  Roster createCopyWithEntryAt(RosterSlot slot, CharacterCopy characterCopy) => switch (slot) {
    InventorySlot(:final index) => createCopyWith(inventory: inventory.createCopyWithEntryAt(index, characterCopy)),
    BoardSlot(:final position) => createCopyWith(
      placements: placements.createCopyWithPlacement(Placement(position: position, characterCopy: characterCopy)),
    ),
  };
}
