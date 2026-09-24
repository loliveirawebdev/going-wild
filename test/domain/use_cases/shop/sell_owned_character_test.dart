import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/character/team/team.dart';
import 'package:going_wild/domain/models/events/phase/phase_event.dart';
import 'package:going_wild/domain/models/player/team_slot/team_slot.dart';
import 'package:going_wild/domain/models/shop/coins_for_selling.dart';
import 'package:going_wild/domain/use_cases/shop/sell_owned_character.dart';

import '../../../helpers/combat_helpers.dart' show at;
import '../../../helpers/phase_helpers.dart';
import '../../../helpers/shop_helpers.dart';

void main() {
  test('selling from the bench frees the slot and pays the coins back', () {
    final phaseRun = phaseRunWith(coins: 1, benchCharacters: [owned(cow, stars: 2)]);

    final hasSold = sellOwnedCharacter(phaseRun, const BenchSlot(index: 0));

    expect(hasSold, isTrue);
    expect(phaseRun.player.bench[0], isNull);
    expect(phaseRun.player.coins, 1 + coinsForSelling(owned(cow, stars: 2), testShopRules));
  });

  test('selling from the field frees the position', () {
    final phaseRun = phaseRunWith(fieldCharacters: {at(6, 2): owned(cat)});

    sellOwnedCharacter(phaseRun, FieldSlot(position: at(6, 2)));

    expect(phaseRun.player.field, isEmpty);
    expect(phaseRun.player.coins, cat.rarity.coins);
  });

  test('records the sale', () {
    final phaseRun = phaseRunWith(benchCharacters: [owned(cow, stars: 2)]);

    sellOwnedCharacter(phaseRun, const BenchSlot(index: 0));

    final sold = phaseRun.events.whereType<CharacterSold>().single;
    expect(sold.character, cow);
    expect(sold.stars, 2);
    expect(sold.slot, const BenchSlot(index: 0));
    expect(sold.coinsReceived, coinsForSelling(owned(cow, stars: 2), testShopRules));
  });

  test('an empty slot or a slot outside the bench and the team half cannot be sold', () {
    final phaseRun = phaseRunWith(benchCharacters: [owned(cat)]);

    expect(sellOwnedCharacter(phaseRun, const BenchSlot(index: 1)), isFalse);
    expect(sellOwnedCharacter(phaseRun, const BenchSlot(index: 99)), isFalse);
    expect(sellOwnedCharacter(phaseRun, FieldSlot(position: at(1, 2))), isFalse);
    expect(phaseRun.player.coins, 0);
    expect(phaseRun.events, isEmpty);
  });
}
