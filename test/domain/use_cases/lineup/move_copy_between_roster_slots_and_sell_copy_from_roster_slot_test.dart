import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/domain/models/inventory/errors/empty_inventory_slot_error.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';

import '../../../helpers/inventory_helpers.dart';
import '../../../helpers/use_case_helpers.dart';

List<String> rosterOf(MatchProgress matchProgress) => [
  for (final entry in matchProgress.playerRoster.entries)
    switch (entry.slot) {
      final InventorySlot slot => '${entry.characterCopy.character.id.value} in inventory ${slot.index}',
      final BoardSlot slot => '${entry.characterCopy.character.id.value} on board ${slot.position}',
    },
];

void main() {
  final matchProgressWithInventory = withInventory(startWith([oneRat]), [characterCopyOf(cat), characterCopyOf(dog)]);
  final matchProgress = matchProgressWithInventory.createCopyWithPlayerPlacements([placed(cow, 6, 0)]);

  group('moving a copy picks the move that matches the two slots', () {
    test('from the inventory to the board', () {
      final moved = moveCopyBetweenRosterSlots(
        matchProgress,
        from: const InventorySlot(index: 0),
        to: BoardSlot(position: at(6, 2)),
      );
      final expected = moveFromInventoryToBoard(matchProgress, inventoryIndex: 0, position: at(6, 2));

      expect(rosterOf(moved), rosterOf(expected));
    });

    test('from the board to the inventory', () {
      final moved = moveCopyBetweenRosterSlots(
        matchProgress,
        from: BoardSlot(position: at(6, 0)),
        to: const InventorySlot(index: 4),
      );
      final expected = moveFromBoardToInventory(matchProgress, position: at(6, 0), inventoryIndex: 4);

      expect(rosterOf(moved), rosterOf(expected));
    });

    test('inside the inventory', () {
      final moved = moveCopyBetweenRosterSlots(matchProgress, from: const InventorySlot(index: 0), to: const InventorySlot(index: 1));
      final expected = moveWithinInventory(matchProgress, toIndex: 1, fromIndex: 0);

      expect(rosterOf(moved), rosterOf(expected));
    });

    test('inside the board', () {
      final moved = moveCopyBetweenRosterSlots(
        matchProgress,
        from: BoardSlot(position: at(6, 0)),
        to: BoardSlot(position: at(5, 4)),
      );
      final expected = moveWithinBoard(matchProgress, toPosition: at(5, 4), fromPosition: at(6, 0));

      expect(rosterOf(moved), rosterOf(expected));
    });

    test('a rejected move keeps the error of the specific move', () {
      expect(
        () => moveCopyBetweenRosterSlots(
          matchProgress,
          from: const InventorySlot(index: 5),
          to: BoardSlot(position: at(6, 2)),
        ),
        throwsA(isA<EmptyInventorySlotError>()),
      );
    });
  });

  group('selling a copy picks the sale that matches the slot', () {
    test('from the inventory', () {
      final sold = sellCopyFromRosterSlot(matchProgress, from: const InventorySlot(index: 1));
      final expected = sellFromInventory(matchProgress, inventoryIndex: 1);

      expect(sold.player.coins, expected.player.coins);
      expect(rosterOf(sold), rosterOf(expected));
    });

    test('from the board', () {
      final sold = sellCopyFromRosterSlot(matchProgress, from: BoardSlot(position: at(6, 0)));
      final expected = sellFromBoard(matchProgress, position: at(6, 0));

      expect(sold.player.coins, expected.player.coins);
      expect(rosterOf(sold), rosterOf(expected));
    });
  });

  test('toggling the shop lock locks an unlocked shop and unlocks a locked one', () {
    final locked = toggleShopLock(matchProgress);
    final unlocked = toggleShopLock(locked);

    expect(matchProgress.shop.isLocked, isFalse);
    expect(locked.shop.isLocked, isTrue);
    expect(unlocked.shop.isLocked, isFalse);
  });
}
