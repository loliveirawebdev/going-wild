import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/data/character/team/team.dart';
import 'package:going_wild/domain/models/events/phase/phase_event.dart';
import 'package:going_wild/domain/models/player/team_slot/team_slot.dart';
import 'package:going_wild/domain/use_cases/player/move_owned_character.dart';

import '../../../helpers/combat_helpers.dart' show at;
import '../../../helpers/phase_helpers.dart';
import '../../../helpers/shop_helpers.dart';

void main() {
  const firstBenchSlot = BenchSlot(index: 0);
  final frontCenter = FieldSlot(position: at(6, 2));

  test('moving from the bench to an empty field position', () {
    final phaseRun = phaseRunWith(level: 2, benchCharacters: [owned(cat)]);

    final hasMoved = moveOwnedCharacter(phaseRun, from: firstBenchSlot, to: frontCenter);

    expect(hasMoved, isTrue);
    expect(phaseRun.player.bench[0], isNull);
    expect(phaseRun.player.field[at(6, 2)]!.character, cat);
  });

  test('moving onto an occupied slot swaps the two characters', () {
    final phaseRun = phaseRunWith(level: 1, benchCharacters: [owned(cat)], fieldCharacters: {at(6, 2): owned(dog)});

    moveOwnedCharacter(phaseRun, from: firstBenchSlot, to: frontCenter);

    expect(phaseRun.player.field[at(6, 2)]!.character, cat);
    expect(phaseRun.player.bench[0]!.character, dog);
  });

  test('the field cannot hold more characters than the player level', () {
    final phaseRun = phaseRunWith(level: 1, benchCharacters: [owned(cat)], fieldCharacters: {at(6, 0): owned(dog)});

    expect(moveOwnedCharacter(phaseRun, from: firstBenchSlot, to: frontCenter), isFalse);
    expect(phaseRun.player.field.keys, [at(6, 0)]);
  });

  test('a full field still allows moving inside the field and back to the bench', () {
    final phaseRun = phaseRunWith(level: 1, fieldCharacters: {at(6, 0): owned(dog)});

    expect(
      moveOwnedCharacter(
        phaseRun,
        from: FieldSlot(position: at(6, 0)),
        to: frontCenter,
      ),
      isTrue,
    );

    expect(moveOwnedCharacter(phaseRun, from: frontCenter, to: firstBenchSlot), isTrue);
    expect(phaseRun.player.field, isEmpty);
    expect(phaseRun.player.bench[0]!.character, dog);
  });

  test('the enemy half, outside the board and outside the bench are not valid destinations', () {
    final phaseRun = phaseRunWith(level: 5, benchCharacters: [owned(cat)]);

    expect(
      moveOwnedCharacter(
        phaseRun,
        from: firstBenchSlot,
        to: FieldSlot(position: at(3, 2)),
      ),
      isFalse,
    );
    expect(
      moveOwnedCharacter(
        phaseRun,
        from: firstBenchSlot,
        to: FieldSlot(position: at(8, 2)),
      ),
      isFalse,
    );
    expect(moveOwnedCharacter(phaseRun, from: firstBenchSlot, to: const BenchSlot(index: 99)), isFalse);
    expect(phaseRun.player.bench[0]!.character, cat);
  });

  test('an empty origin or the same slot does nothing', () {
    final phaseRun = phaseRunWith(level: 5, benchCharacters: [owned(cat)]);

    expect(moveOwnedCharacter(phaseRun, from: const BenchSlot(index: 1), to: frontCenter), isFalse);
    expect(moveOwnedCharacter(phaseRun, from: firstBenchSlot, to: firstBenchSlot), isFalse);
    expect(phaseRun.events, isEmpty);
  });

  test('records the move', () {
    final phaseRun = phaseRunWith(level: 2, benchCharacters: [owned(cat, stars: 2)]);

    moveOwnedCharacter(phaseRun, from: firstBenchSlot, to: frontCenter);

    final moved = phaseRun.events.whereType<OwnedCharacterMoved>().single;
    expect(moved.character, cat);
    expect(moved.stars, 2);
    expect(moved.from, firstBenchSlot);
    expect(moved.to, frontCenter);
  });
}
