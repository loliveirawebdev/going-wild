import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/character/team/team.dart';
import 'package:going_wild/domain/models/events/phase/phase_event.dart';
import 'package:going_wild/domain/models/player/team_slot/team_slot.dart';
import 'package:going_wild/domain/models/shop/merge_owned_characters.dart';

import '../../../helpers/combat_helpers.dart' show at;
import '../../../helpers/phase_helpers.dart';
import '../../../helpers/shop_helpers.dart';

void main() {
  test('two one-star copies become one two-star', () {
    final phaseRun = phaseRunWith(benchCharacters: [owned(cat), owned(cat)]);
    mergeOwnedCharacters(phaseRun);
    expect(ownedCharactersOf(phaseRun.player), [(character: cat, stars: 2)]);
  });

  test('every merge is recorded with the new stars', () {
    final phaseRun = phaseRunWith(benchCharacters: [owned(cat, stars: 2), owned(cat), owned(cat)]);
    mergeOwnedCharacters(phaseRun);
    final merges = phaseRun.events.whereType<CharactersMerged>().map((merged) => (merged.character, merged.newStars));
    expect(merges, [(cat, 2), (cat, 3)]);
  });

  test('no merge records nothing', () {
    final phaseRun = phaseRunWith(benchCharacters: [owned(cat), owned(dog)]);
    mergeOwnedCharacters(phaseRun);
    expect(phaseRun.events, isEmpty);
  });

  test('a third copy waits for a partner', () {
    final phaseRun = phaseRunWith(benchCharacters: [owned(cat), owned(cat), owned(cat)]);
    mergeOwnedCharacters(phaseRun);
    expect(ownedCharactersOf(phaseRun.player), unorderedEquals([(character: cat, stars: 2), (character: cat, stars: 1)]));
  });

  test('merges cascade: a new two-star joins an existing two-star', () {
    final phaseRun = phaseRunWith(benchCharacters: [owned(cat, stars: 2), owned(cat), owned(cat)]);
    mergeOwnedCharacters(phaseRun);
    expect(ownedCharactersOf(phaseRun.player), [(character: cat, stars: 3)]);
  });

  test('different characters never merge', () {
    final phaseRun = phaseRunWith(benchCharacters: [owned(cat), owned(dog)]);
    mergeOwnedCharacters(phaseRun);
    expect(ownedCharactersOf(phaseRun.player), unorderedEquals([(character: cat, stars: 1), (character: dog, stars: 1)]));
  });

  test('max star copies never merge', () {
    final phaseRun = phaseRunWith(
      benchCharacters: [
        owned(cat, stars: testShopRules.maxStars),
        owned(cat, stars: testShopRules.maxStars),
      ],
    );
    mergeOwnedCharacters(phaseRun);
    expect(phaseRun.player.ownedCharacters, hasLength(2));
  });

  test('the number of copies per merge comes from the rules', () {
    final phaseRun = phaseRunWith(shopRules: shopRulesWith(copiesPerMerge: 3), benchCharacters: [owned(cat), owned(cat)]);

    mergeOwnedCharacters(phaseRun);
    expect(ownedCharactersOf(phaseRun.player), [(character: cat, stars: 1), (character: cat, stars: 1)]);

    phaseRun.player.placeOwnedCharacterAt(phaseRun.player.firstFreeBenchSlot!, owned(cat));
    mergeOwnedCharacters(phaseRun);
    expect(ownedCharactersOf(phaseRun.player), [(character: cat, stars: 2)]);
  });

  test('the merged character lands where the first copy was, preferring the field', () {
    final phaseRun = phaseRunWith(benchCharacters: [owned(cat), owned(dog)], fieldCharacters: {at(6, 2): owned(cat)});

    mergeOwnedCharacters(phaseRun);

    expect(phaseRun.player.field[at(6, 2)]!.stars, 2);
    expect(phaseRun.player.bench[0], isNull);
    expect(phaseRun.player.bench[1]!.character, dog);
    expect(phaseRun.events.whereType<CharactersMerged>().single.slot, FieldSlot(position: at(6, 2)));
  });

  test('on the bench the merged character lands on the lowest slot', () {
    final phaseRun = phaseRunWith(benchCharacters: [owned(dog), owned(cat), owned(rabbit), owned(cat)]);

    mergeOwnedCharacters(phaseRun);

    expect(phaseRun.player.bench[1]!.stars, 2);
    expect(phaseRun.player.bench[3], isNull);
  });
}
