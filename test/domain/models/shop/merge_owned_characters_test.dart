import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/character/team/team.dart';
import 'package:going_wild/domain/models/shop/merge_owned_characters.dart';

import '../../../helpers/shop_helpers.dart';

void main() {
  test('two one-star copies become one two-star', () {
    final player = playerWith(ownedCharacters: [owned(cat), owned(cat)]);
    mergeOwnedCharacters(player, testShopRules);
    expect(ownedCharactersOf(player), [(character: cat, stars: 2)]);
  });

  test('a third copy waits for a partner', () {
    final player = playerWith(ownedCharacters: [owned(cat), owned(cat), owned(cat)]);
    mergeOwnedCharacters(player, testShopRules);
    expect(ownedCharactersOf(player), unorderedEquals([(character: cat, stars: 2), (character: cat, stars: 1)]));
  });

  test('merges cascade: a new two-star joins an existing two-star', () {
    final player = playerWith(ownedCharacters: [owned(cat, stars: 2), owned(cat), owned(cat)]);
    mergeOwnedCharacters(player, testShopRules);
    expect(ownedCharactersOf(player), [(character: cat, stars: 3)]);
  });

  test('different characters never merge', () {
    final player = playerWith(ownedCharacters: [owned(cat), owned(dog)]);
    mergeOwnedCharacters(player, testShopRules);
    expect(ownedCharactersOf(player), unorderedEquals([(character: cat, stars: 1), (character: dog, stars: 1)]));
  });

  test('max star copies never merge', () {
    final player = playerWith(
      ownedCharacters: [
        owned(cat, stars: testShopRules.maxStars),
        owned(cat, stars: testShopRules.maxStars),
      ],
    );
    mergeOwnedCharacters(player, testShopRules);
    expect(player.ownedCharacters, hasLength(2));
  });

  test('the number of copies per merge comes from the rules', () {
    final rulesWithThreeCopies = shopRulesWith(copiesPerMerge: 3);
    final player = playerWith(ownedCharacters: [owned(cat), owned(cat)]);

    mergeOwnedCharacters(player, rulesWithThreeCopies);
    expect(ownedCharactersOf(player), [(character: cat, stars: 1), (character: cat, stars: 1)]);

    player.ownedCharacters.add(owned(cat));
    mergeOwnedCharacters(player, rulesWithThreeCopies);
    expect(ownedCharactersOf(player), [(character: cat, stars: 2)]);
  });
}
