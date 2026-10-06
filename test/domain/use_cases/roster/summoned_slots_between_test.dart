import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/roster/roster.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';
import 'package:going_wild/domain/use_cases/roster/summoned_slots_between.dart';

import '../../../helpers/inventory_helpers.dart';

const catCopy = CharacterCopy(stars: 1, character: cat);
const dogCopy = CharacterCopy(stars: 1, character: dog);
const fieldPosition = Position(row: 5, column: 1);
const otherFieldPosition = Position(row: 5, column: 2);

String describe(List<RosterSlot> slots) => slots.map((slot) => slot.toString()).join(', ');

void main() {
  test('a copy that leaves the bench for the field is summoned on its cell', () {
    final previous = Roster(inventory: inventoryWith([catCopy]), placements: const []);
    final current = Roster(
      inventory: inventoryWith([]),
      placements: const [Placement(position: fieldPosition, characterCopy: catCopy)],
    );

    expect(describe(summonedSlotsBetween(previous: previous, current: current)), 'board $fieldPosition');
  });

  test('a copy that comes back from the field is summoned on its bench slot', () {
    final previous = Roster(
      inventory: inventoryWith([]),
      placements: const [Placement(position: fieldPosition, characterCopy: catCopy)],
    );
    final current = Roster(inventory: inventoryWith([catCopy]), placements: const []);

    expect(describe(summonedSlotsBetween(previous: previous, current: current)), 'inventory 0');
  });

  test('moving inside the field or inside the bench summons nobody', () {
    final previous = Roster(
      inventory: inventoryWith([dogCopy]),
      placements: const [Placement(position: fieldPosition, characterCopy: catCopy)],
    );
    final current = Roster(
      inventory: inventoryWith([]).createCopyWithEntryAt(1, dogCopy),
      placements: const [Placement(position: otherFieldPosition, characterCopy: catCopy)],
    );

    expect(summonedSlotsBetween(previous: previous, current: current), isEmpty);
  });

  test('a bought copy arrives on the bench without a summon', () {
    final previous = Roster(inventory: inventoryWith([]), placements: const []);
    final current = Roster(inventory: inventoryWith([characterCopyOf(cat)]), placements: const []);

    expect(summonedSlotsBetween(previous: previous, current: current), isEmpty);
  });

  test('a copy that gains a star is summoned wherever it lands, on the field or on the bench', () {
    final previous = Roster(
      inventory: inventoryWith([dogCopy, characterCopyOf(dog)]),
      placements: const [Placement(position: fieldPosition, characterCopy: catCopy)],
    );
    final current = Roster(
      inventory: inventoryWith([characterCopyOf(dog, stars: 2)]),
      placements: [Placement(position: fieldPosition, characterCopy: characterCopyOf(cat, stars: 2))],
    );

    expect(describe(summonedSlotsBetween(previous: previous, current: current)), 'board $fieldPosition, inventory 0');
  });
}
