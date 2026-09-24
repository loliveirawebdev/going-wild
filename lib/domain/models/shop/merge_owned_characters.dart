import '../character/character.dart';
import '../events/phase/phase_event.dart';
import '../phase/phase_run.dart';
import '../player/team_slot/team_slot.dart';
import 'owned_character.dart';

void mergeOwnedCharacters(PhaseRun phaseRun) {
  var hasMerged = true;
  while (hasMerged) hasMerged = _mergeFirstGroupOfCopies(phaseRun);
}

void mergeCopiesIntoFirstSlot(
  PhaseRun phaseRun, {
  required Character character,
  required int starsBeforeMerge,
  required List<TeamSlot> copySlots,
}) {
  final player = phaseRun.player;
  for (final copySlot in copySlots) player.placeOwnedCharacterAt(copySlot, null);

  final newStars = starsBeforeMerge + 1;
  final mergedSlot = copySlots.first;
  player.placeOwnedCharacterAt(mergedSlot, OwnedCharacter(character: character, stars: newStars));

  phaseRun.recordEvent(
    CharactersMerged(
      roundNumber: phaseRun.currentRoundNumber,
      character: character,
      newStars: newStars,
      slot: mergedSlot,
    ),
  );
}

bool _mergeFirstGroupOfCopies(PhaseRun phaseRun) {
  final rules = phaseRun.rules.shopRules;
  final occupiedTeamSlots = phaseRun.player.occupiedTeamSlots;

  for (final (slot: _, :ownedCharacter) in occupiedTeamSlots) {
    if (ownedCharacter.stars >= rules.maxStars) continue;

    final copySlots = occupiedTeamSlots
        .where(
          (occupied) =>
              occupied.ownedCharacter.character == ownedCharacter.character && occupied.ownedCharacter.stars == ownedCharacter.stars,
        )
        .map((occupied) => occupied.slot)
        .take(rules.copiesPerMerge)
        .toList();

    if (copySlots.length < rules.copiesPerMerge) continue;

    mergeCopiesIntoFirstSlot(phaseRun, character: ownedCharacter.character, starsBeforeMerge: ownedCharacter.stars, copySlots: copySlots);
    return true;
  }

  return false;
}
