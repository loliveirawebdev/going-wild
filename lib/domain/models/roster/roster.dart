import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/board/placement_list.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/inventory/inventory.dart';
import 'package:going_wild/domain/models/roster/roster_entry.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';
import 'package:meta/meta.dart';

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
