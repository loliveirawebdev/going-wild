import '../../models/events/phase/phase_event.dart';
import '../../models/phase/phase_run.dart';
import '../../models/shop/merge_owned_characters.dart';
import '../../models/shop/owned_character.dart';

bool buyShopOffer(PhaseRun phaseRun, int offerIndex) {
  final player = phaseRun.player;
  final offeredCharacter = player.shopOffers[offerIndex];
  if (offeredCharacter == null || player.coins < offeredCharacter.rarity.coins) return false;

  player.coins -= offeredCharacter.rarity.coins;
  player.shopOffers[offerIndex] = null;
  player.ownedCharacters.add(OwnedCharacter(character: offeredCharacter, stars: 1));

  phaseRun.recordEvent(
    CharacterBought(
      roundNumber: phaseRun.currentRoundNumber,
      character: offeredCharacter,
      offerIndex: offerIndex,
      coinsSpent: offeredCharacter.rarity.coins,
    ),
  );

  mergeOwnedCharacters(phaseRun);
  return true;
}
