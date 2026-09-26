import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/engines/character/basic_character_engine.dart';
import 'package:going_wild/content/engines/inventory/basic_inventory_engine.dart';
import 'package:going_wild/content/engines/merge/basic_merge_engine.dart';
import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/merge/engines/basic_merge_engine.dart';
import 'package:going_wild/domain/models/merge/merge.dart';
import 'package:going_wild/domain/models/roster/roster.dart';

import '../../../../helpers/inventory_helpers.dart';
import '../../../../helpers/use_case_helpers.dart';

final oneStarCat = characterCopyOf(cat);
final oneStarDog = characterCopyOf(dog);
final oneStarCow = characterCopyOf(cow);
final twoStarCat = characterCopyOf(cat, stars: 2);
final maxStarCat = characterCopyOf(cat, stars: basicCharacterEngine.maxStars);

Merge? findMergeIn(List<CharacterCopy> characterCopies, {int? copiesPerMerge}) {
  final mergeEngine = BasicMergeEngine(copiesPerMerge: copiesPerMerge ?? basicMergeEngine.copiesPerMerge);
  return mergeEngine.findMerge(characterCopies, maxStars: basicCharacterEngine.maxStars);
}

void main() {
  test('two one-star copies merge into a two-star', () {
    final merge = findMergeIn([oneStarCat, oneStarCat]);

    expect(merge!.copyIndexes, [0, 1]);
    expect(merge.newStars, 2);
  });

  test('copies do not need to be next to each other', () {
    final merge = findMergeIn([oneStarCat, oneStarDog, oneStarCow, oneStarCat]);
    expect(merge!.copyIndexes, [0, 3]);
  });

  test('a third copy waits for a partner and the first ones in the list merge', () {
    final merge = findMergeIn([oneStarCat, oneStarCat, oneStarCat]);
    expect(merge!.copyIndexes, [0, 1]);
  });

  test('copies with different stars do not merge', () {
    expect(findMergeIn([oneStarCat, twoStarCat]), isNull);
  });

  test('different characters never merge', () {
    expect(findMergeIn([oneStarCat, oneStarDog]), isNull);
  });

  test('max star copies never merge', () {
    expect(findMergeIn([maxStarCat, maxStarCat]), isNull);
  });

  test('two-star copies merge into a three-star', () {
    final merge = findMergeIn([oneStarDog, twoStarCat, twoStarCat]);

    expect(merge!.copyIndexes, [1, 2]);
    expect(merge.newStars, 3);
  });

  test('the number of copies per merge comes from the rules', () {
    final mergeOfThree = findMergeIn([oneStarCat, oneStarCat, oneStarCat], copiesPerMerge: 3);

    expect(findMergeIn([oneStarCat, oneStarCat], copiesPerMerge: 3), isNull);
    expect(mergeOfThree!.copyIndexes, [0, 1, 2]);
  });

  test('copies inside a character grow with the copies per merge at every star', () {
    const mergeOfThree = BasicMergeEngine(copiesPerMerge: 3);

    expect([1, 2, 3].map(basicMergeEngine.copiesInside), [1, 2, 4]);
    expect([1, 2, 3].map(mergeOfThree.copiesInside), [1, 3, 9]);
  });

  test('an empty list has nothing to merge', () {
    expect(findMergeIn([]), isNull);
  });

  group('merging a new copy into the roster', () {
    Roster rosterOf({int capacity = 3, List<Placement> placements = const [], List<CharacterCopy> inventory = const []}) => Roster(
      placements: placements,
      inventory: inventoryWith(inventory, capacity: capacity),
    );

    Roster? mergeNewCopy(Roster roster, CharacterCopy newCharacterCopy) => basicMergeEngine.mergeWithNewCopy(
      roster,
      newCharacterCopy,
      maxStars: basicCharacterEngine.maxStars,
      inventoryEngine: basicCharacterInventoryEngine,
    );

    test('a copy that merges with nothing goes to the first free inventory slot', () {
      final mergedRoster = mergeNewCopy(rosterOf(inventory: [oneStarDog]), oneStarCat)!;

      expect(mergedRoster.inventory.entryAt(1)!.character, cat);
    });

    test('a copy that merges with nothing does not fit in a full inventory', () {
      expect(mergeNewCopy(rosterOf(capacity: 1, inventory: [oneStarDog]), oneStarCat), isNull);
    });

    test('a copy that completes a merge fits even in a full inventory', () {
      final mergedRoster = mergeNewCopy(rosterOf(capacity: 1, inventory: [oneStarCat]), oneStarCat)!;

      expect(mergedRoster.inventory.entryAt(0)!.stars, 2);
    });

    test('merges cascade: the new two-star joins an existing two-star', () {
      final mergedRoster = mergeNewCopy(rosterOf(inventory: [twoStarCat, oneStarCat]), oneStarCat)!;

      expect(mergedRoster.characterCopies.map((characterCopy) => (characterCopy.character, characterCopy.stars)), [(cat, 3)]);
    });

    test('the merged copy lands where the first copy was, even on the board', () {
      final placements = [Placement(position: at(6, 2), characterCopy: oneStarCat)];
      final mergedRoster = mergeNewCopy(rosterOf(placements: placements), oneStarCat)!;

      expect(mergedRoster.placements.single.position, at(6, 2));
      expect(mergedRoster.placements.single.characterCopy.stars, 2);
      expect(mergedRoster.inventory.entries, isEmpty);
    });
  });
}
