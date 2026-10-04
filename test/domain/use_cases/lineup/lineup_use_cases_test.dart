import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/engines/economy/basic_economy_engine.dart';
import 'package:going_wild/domain/models/board/errors/no_placement_at_position_error.dart';
import 'package:going_wild/domain/models/board/errors/position_outside_team_half_error.dart';
import 'package:going_wild/domain/models/board/errors/team_is_full_error.dart';
import 'package:going_wild/domain/models/inventory/errors/empty_inventory_slot_error.dart';
import 'package:going_wild/domain/models/inventory/errors/inventory_index_out_of_range_error.dart';

import '../../../helpers/inventory_helpers.dart';
import '../../../helpers/use_case_helpers.dart';

void main() {
  group('moving', () {
    test('a character moves from the inventory to the board and back', () {
      final matchProgress = withInventory(startWith([oneRat]), [characterCopyOf(cat)]);

      final onBoard = moveFromInventoryToBoard(matchProgress, inventoryIndex: 0, position: at(6, 2));
      expect(onBoard.playerRoster.placements.single.characterCopy.character, cat);
      expect(onBoard.playerRoster.inventory.entryAt(0), isNull);

      final backOnInventory = moveFromBoardToInventory(onBoard, inventoryIndex: 4, position: at(6, 2));
      expect(backOnInventory.playerRoster.placements, isEmpty);
      expect(backOnInventory.playerRoster.inventory.entryAt(4)!.character, cat);
    });

    test('the board holds at most as many characters as the level', () {
      final matchProgress = withInventory(startWith([oneRat]), [characterCopyOf(cat), characterCopyOf(dog), characterCopyOf(cow)]);
      expect(matchProgress.playerLevelProgress.level.number, 2);

      final oneOnBoard = moveFromInventoryToBoard(matchProgress, inventoryIndex: 0, position: at(6, 0));
      final twoOnBoard = moveFromInventoryToBoard(oneOnBoard, inventoryIndex: 1, position: at(6, 1));

      expect(() => moveFromInventoryToBoard(twoOnBoard, inventoryIndex: 2, position: at(6, 2)), throwsA(isA<TeamIsFullError>()));
    });

    test('moving onto an occupied spot swaps the two characters', () {
      final matchProgressWithInventory = withInventory(startWith([oneRat]), [characterCopyOf(cat)]);
      final matchProgress = matchProgressWithInventory.createCopyWithPlayerPlacements([placed(dog, 6, 2)]);

      final swapped = moveFromInventoryToBoard(matchProgress, inventoryIndex: 0, position: at(6, 2));

      expect(swapped.playerRoster.placements.single.characterCopy.character, cat);
      expect(swapped.playerRoster.inventory.entryAt(0)!.character, dog);
    });

    test('characters move and swap inside the inventory and inside the board', () {
      final matchProgressWithInventory = withInventory(startWith([oneRat]), [characterCopyOf(cat), characterCopyOf(dog)]);
      final matchProgress = matchProgressWithInventory.createCopyWithPlayerPlacements([placed(cow, 6, 0), placed(goat, 6, 4)]);

      final inventorySwapped = moveWithinInventory(matchProgress, toIndex: 1, fromIndex: 0);
      expect(inventorySwapped.playerRoster.inventory.entries.map((characterCopy) => characterCopy.character), [dog, cat]);

      final boardSwapped = moveWithinBoard(matchProgress, toPosition: at(6, 4), fromPosition: at(6, 0));
      expect(boardSwapped.playerRoster.placements.map((placement) => (placement.characterCopy.character, placement.position)), [
        (goat, at(6, 0)),
        (cow, at(6, 4)),
      ]);
    });

    test('the enemy half, outside the inventory and empty origins fail with their own errors', () {
      final matchProgress = withInventory(startWith([oneRat]), [characterCopyOf(cat)]);

      expect(
        () => moveFromInventoryToBoard(matchProgress, inventoryIndex: 0, position: at(1, 2)),
        throwsA(isA<PositionOutsideTeamHalfError>()),
      );
      expect(
        () => moveFromInventoryToBoard(matchProgress, inventoryIndex: -1, position: at(6, 2)),
        throwsA(isA<InventoryIndexOutOfRangeError>()),
      );
      expect(() => moveFromInventoryToBoard(matchProgress, inventoryIndex: 3, position: at(6, 2)), throwsA(isA<EmptyInventorySlotError>()));
    });
  });

  group('selling', () {
    test('selling from the inventory or the board pays the sell price and frees the spot', () {
      final matchProgressWithInventory = withInventory(startWith([oneRat]), [characterCopyOf(cow, stars: 2)]);
      final matchProgress = matchProgressWithInventory.createCopyWithPlayerPlacements([placed(cat, 6, 2)]);

      final soldFromInventory = sellFromInventory(matchProgress, inventoryIndex: 0);
      expect(soldFromInventory.playerRoster.inventory.entries, isEmpty);
      expect(
        soldFromInventory.player.coins,
        matchProgress.player.coins + basicEconomyEngine.sellPriceOf(characterCopyOf(cow, stars: 2), matchProgress: matchProgress),
      );

      final soldFromBoard = sellFromBoard(matchProgress, position: at(6, 2));
      expect(soldFromBoard.playerRoster.placements, isEmpty);
      expect(soldFromBoard.player.coins, matchProgress.player.coins + basicEconomyEngine.priceOfRarity(cat.rarity));
    });

    test('selling an empty spot fails', () {
      final matchProgress = startWith([oneRat]);
      expect(() => sellFromInventory(matchProgress, inventoryIndex: 0), throwsA(isA<EmptyInventorySlotError>()));
      expect(() => sellFromBoard(matchProgress, position: at(6, 2)), throwsA(isA<NoPlacementAtPositionError>()));
    });
  });

  test('moving inside the board fails outside the team half or from an empty position', () {
    final matchProgress = startWith([oneRat]).createCopyWithPlayerPlacements([placed(cat, 6, 2)]);
    expect(
      () => moveWithinBoard(matchProgress, toPosition: at(1, 2), fromPosition: at(6, 2)),
      throwsA(isA<PositionOutsideTeamHalfError>()),
    );
    expect(() => moveWithinBoard(matchProgress, toPosition: at(6, 1), fromPosition: at(6, 0)), throwsA(isA<NoPlacementAtPositionError>()));
  });

  test('moving a character onto its own spot changes nothing', () {
    final matchProgressWithInventory = withInventory(startWith([oneRat]), [characterCopyOf(cat)]);
    final matchProgress = matchProgressWithInventory.createCopyWithPlayerPlacements([placed(dog, 6, 2)]);
    expect(moveWithinInventory(matchProgress, toIndex: 0, fromIndex: 0), same(matchProgress));
    expect(moveWithinBoard(matchProgress, toPosition: at(6, 2), fromPosition: at(6, 2)), same(matchProgress));
  });

  test('moving from an empty inventory slot fails', () {
    final matchProgress = startWith([oneRat]);
    expect(() => moveWithinInventory(matchProgress, toIndex: 1, fromIndex: 0), throwsA(isA<EmptyInventorySlotError>()));
    expect(
      () => moveFromBoardToInventory(matchProgress, inventoryIndex: 0, position: at(6, 2)),
      throwsA(isA<NoPlacementAtPositionError>()),
    );
  });
}
