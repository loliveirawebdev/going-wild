import '../combat/board/position.dart';
import '../models.dart';
import '../shop/owned_character.dart';
import 'team_slot/team_slot.dart';

typedef OccupiedTeamSlot = ({TeamSlot slot, OwnedCharacter ownedCharacter});

class Player {
  Player({required this.coins, required int benchSize}) : bench = List.filled(benchSize, null);

  int coins;
  int level = 1;
  int experience = 0;
  bool isShopLocked = false;
  List<Character?> shopOffers = [];
  final List<OwnedCharacter?> bench;
  final Map<Position, OwnedCharacter> field = {};

  List<OwnedCharacter> get ownedCharacters => [
    ...field.values,
    ...bench.nonNulls,
  ];

  List<OccupiedTeamSlot> get occupiedTeamSlots => [
    for (final MapEntry(key: position, value: ownedCharacter) in field.entries)
      (slot: FieldSlot(position: position), ownedCharacter: ownedCharacter),
    for (final (index, ownedCharacter) in bench.indexed)
      if (ownedCharacter != null) (slot: BenchSlot(index: index), ownedCharacter: ownedCharacter),
  ];

  BenchSlot? get firstFreeBenchSlot {
    final freeIndex = bench.indexOf(null);
    return freeIndex == -1 ? null : BenchSlot(index: freeIndex);
  }

  OwnedCharacter? ownedCharacterAt(TeamSlot slot) => switch (slot) {
    BenchSlot() => bench[slot.index],
    FieldSlot() => field[slot.position],
  };

  void placeOwnedCharacterAt(TeamSlot slot, OwnedCharacter? ownedCharacter) {
    switch (slot) {
      case BenchSlot():
        bench[slot.index] = ownedCharacter;

      case FieldSlot():
        if (ownedCharacter == null) field.remove(slot.position);
        if (ownedCharacter != null) field[slot.position] = ownedCharacter;
    }
  }
}
