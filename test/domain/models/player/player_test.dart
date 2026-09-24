import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/character/team/team.dart';
import 'package:going_wild/domain/models/player/team_slot/team_slot.dart';

import '../../../helpers/combat_helpers.dart' show at;
import '../../../helpers/shop_helpers.dart';

void main() {
  test('a new player has an empty bench of the given size and an empty field', () {
    final player = playerWith(benchSize: 9);
    expect(player.bench, hasLength(9));
    expect(player.bench, everyElement(isNull));
    expect(player.field, isEmpty);
    expect(player.ownedCharacters, isEmpty);
  });

  test('owned characters are the field ones followed by the bench ones', () {
    final player = playerWith(benchCharacters: [owned(cat), owned(dog)], fieldCharacters: {at(6, 2): owned(cow)});
    expect(ownedCharactersOf(player).map((owned) => owned.character), [cow, cat, dog]);
  });

  test('occupied slots list the field first and then the bench in order', () {
    final player = playerWith(benchCharacters: [owned(cat)], fieldCharacters: {at(6, 2): owned(cow)});
    player.bench[3] = owned(dog);

    expect(player.occupiedTeamSlots.map((occupied) => occupied.slot), [
      FieldSlot(position: at(6, 2)),
      const BenchSlot(index: 0),
      const BenchSlot(index: 3),
    ]);
  });

  test('the first free bench slot skips occupied ones and is null when the bench is full', () {
    final player = playerWith(benchSize: 2, benchCharacters: [owned(cat)]);
    expect(player.firstFreeBenchSlot, const BenchSlot(index: 1));

    player.bench[1] = owned(dog);
    expect(player.firstFreeBenchSlot, isNull);
  });

  test('placing and clearing works on both bench and field', () {
    final player = playerWith();
    final fieldSlot = FieldSlot(position: at(6, 2));

    player.placeOwnedCharacterAt(const BenchSlot(index: 4), owned(cat));
    player.placeOwnedCharacterAt(fieldSlot, owned(dog));
    expect(player.ownedCharacterAt(const BenchSlot(index: 4))!.character, cat);
    expect(player.ownedCharacterAt(fieldSlot)!.character, dog);

    player.placeOwnedCharacterAt(fieldSlot, null);
    expect(player.field, isEmpty);
  });
}
