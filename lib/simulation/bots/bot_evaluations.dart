import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/character/role.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';

typedef IndexedCharacterCopy = ({int index, CharacterCopy characterCopy});

int teamSizeOf(MatchProgress matchProgress) => matchProgress.playerLevelProgress.level.teamSize;

int priceOf(MatchProgress matchProgress, Character character) =>
    matchProgress.phase.engines.economyEngine.priceOf(character, matchProgress: matchProgress);

int strengthOf(MatchProgress matchProgress, CharacterCopy characterCopy) {
  final price = priceOf(matchProgress, characterCopy.character);
  final copiesInside = matchProgress.phase.engines.mergeEngine.copiesInside(characterCopy.stars);
  return price * copiesInside;
}

bool isFrontLiner(Character character) => character.role == Role.tank || character.role == Role.guard;

List<CharacterCopy> ownedCharacterCopiesOf(MatchProgress matchProgress) => matchProgress.playerRoster.characterCopies;

List<CharacterCopy> strongestFirst(MatchProgress matchProgress) =>
    ownedCharacterCopiesOf(matchProgress)
      ..sort((first, second) => strengthOf(matchProgress, second).compareTo(strengthOf(matchProgress, first)));

IndexedCharacterCopy? weakestBenchedOf(MatchProgress matchProgress) {
  IndexedCharacterCopy? weakestBenched;

  for (final indexedEntry in matchProgress.playerRoster.inventory.indexedEntries) {
    final isWeaker =
        weakestBenched == null || strengthOf(matchProgress, indexedEntry.entry) < strengthOf(matchProgress, weakestBenched.characterCopy);
    if (isWeaker) weakestBenched = (index: indexedEntry.index, characterCopy: indexedEntry.entry);
  }

  return weakestBenched;
}
