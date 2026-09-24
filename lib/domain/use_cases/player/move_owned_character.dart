import '../../models/events/phase/phase_event.dart';
import '../../models/phase/phase_run.dart';
import '../../models/player/team_slot/is_valid_team_slot.dart';
import '../../models/player/team_slot/team_slot.dart';

bool moveOwnedCharacter(PhaseRun phaseRun, {required TeamSlot from, required TeamSlot to}) {
  final player = phaseRun.player;
  if (from == to || !isValidTeamSlot(phaseRun, from) || !isValidTeamSlot(phaseRun, to)) return false;

  final movingCharacter = player.ownedCharacterAt(from);
  if (movingCharacter == null) return false;

  final displacedCharacter = player.ownedCharacterAt(to);
  final addsOneMoreToTheField = from is BenchSlot && to is FieldSlot && displacedCharacter == null;
  if (addsOneMoreToTheField && player.field.length >= player.level) return false;

  player.placeOwnedCharacterAt(from, displacedCharacter);
  player.placeOwnedCharacterAt(to, movingCharacter);

  phaseRun.recordEvent(
    OwnedCharacterMoved(
      roundNumber: phaseRun.currentRoundNumber,
      character: movingCharacter.character,
      stars: movingCharacter.stars,
      from: from,
      to: to,
    ),
  );

  return true;
}
