import '../../models/events/phase/phase_event.dart';
import '../../models/phase/phase_run.dart';
import '../../models/player/team_slot/is_valid_team_slot.dart';
import '../../models/player/team_slot/team_slot.dart';
import '../../models/shop/coins_for_selling.dart';

bool sellOwnedCharacter(PhaseRun phaseRun, TeamSlot slot) {
  if (!phaseRun.isInProgress) return false;

  final player = phaseRun.player;
  if (!isValidTeamSlot(phaseRun, slot)) return false;

  final ownedCharacter = player.ownedCharacterAt(slot);
  if (ownedCharacter == null) return false;

  final coinsReceived = coinsForSelling(ownedCharacter, phaseRun.rules.shopRules);
  player.placeOwnedCharacterAt(slot, null);
  player.coins += coinsReceived;

  phaseRun.recordEvent(
    CharacterSold(
      roundNumber: phaseRun.currentRoundNumber,
      character: ownedCharacter.character,
      stars: ownedCharacter.stars,
      slot: slot,
      coinsReceived: coinsReceived,
    ),
  );

  return true;
}
