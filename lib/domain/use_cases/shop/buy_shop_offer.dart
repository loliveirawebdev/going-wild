import '../../models/events/phase/phase_event.dart';
import '../../models/phase/phase_run.dart';
import '../../models/shop/merge_owned_characters.dart';
import '../../models/shop/owned_character.dart';

bool buyShopOffer(PhaseRun phaseRun, int offerIndex) {
  if (!phaseRun.isInProgress) return false;

  final player = phaseRun.player;
  final offeredCharacter = player.shopOffers[offerIndex];
  final copiesPerMerge = phaseRun.rules.shopRules.copiesPerMerge;
  if (offeredCharacter == null || player.coins < offeredCharacter.rarity.coins) return false;

  final oneStarCopySlots = player.occupiedTeamSlots
      .where((occupied) => occupied.ownedCharacter.character == offeredCharacter && occupied.ownedCharacter.stars == 1)
      .map((occupied) => occupied.slot)
      .take(copiesPerMerge - 1)
      .toList();

  final completesAMerge = oneStarCopySlots.length == copiesPerMerge - 1;
  final freeBenchSlot = player.firstFreeBenchSlot;
  if (!completesAMerge && freeBenchSlot == null) return false;

  player.coins -= offeredCharacter.rarity.coins;
  player.shopOffers[offerIndex] = null;

  phaseRun.recordEvent(
    CharacterBought(
      roundNumber: phaseRun.currentRoundNumber,
      character: offeredCharacter,
      offerIndex: offerIndex,
      coinsSpent: offeredCharacter.rarity.coins,
    ),
  );

  if (!completesAMerge) {
    player.placeOwnedCharacterAt(freeBenchSlot!, OwnedCharacter(character: offeredCharacter, stars: 1));
    return true;
  }

  mergeCopiesIntoFirstSlot(phaseRun, character: offeredCharacter, starsBeforeMerge: 1, copySlots: oneStarCopySlots);
  mergeOwnedCharacters(phaseRun);
  return true;
}
