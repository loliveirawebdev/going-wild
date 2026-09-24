import '../events/phase/phase_event.dart';
import '../phase/phase_run.dart';
import 'owned_character.dart';

void mergeOwnedCharacters(PhaseRun phaseRun) {
  var hasMerged = true;
  while (hasMerged) hasMerged = _mergeFirstGroupOfCopies(phaseRun);
}

bool _mergeFirstGroupOfCopies(PhaseRun phaseRun) {
  final player = phaseRun.player;
  final rules = phaseRun.rules.shopRules;

  for (final ownedCharacter in player.ownedCharacters) {
    if (ownedCharacter.stars >= rules.maxStars) continue;

    final copies = player.ownedCharacters
        .where((otherOwnedChar) => otherOwnedChar.character == ownedCharacter.character && otherOwnedChar.stars == ownedCharacter.stars)
        .take(rules.copiesPerMerge)
        .toList();

    if (copies.length < rules.copiesPerMerge) continue;

    for (final copy in copies) player.ownedCharacters.remove(copy);
    final newStars = ownedCharacter.stars + 1;
    player.ownedCharacters.add(OwnedCharacter(character: ownedCharacter.character, stars: newStars));

    phaseRun.recordEvent(
      CharactersMerged(
        roundNumber: phaseRun.currentRoundNumber,
        character: ownedCharacter.character,
        newStars: newStars,
      ),
    );

    return true;
  }

  return false;
}
