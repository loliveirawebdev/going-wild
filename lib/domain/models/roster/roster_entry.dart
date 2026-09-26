import '../character/character_copy.dart';
import 'roster_slot.dart';

class RosterEntry {
  const RosterEntry({required this.slot, required this.characterCopy});
  final CharacterCopy characterCopy;
  final RosterSlot slot;
}
