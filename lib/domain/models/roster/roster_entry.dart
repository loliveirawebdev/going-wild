import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/domain/models/roster/roster_slot.dart';

class RosterEntry {
  const RosterEntry({required this.slot, required this.characterCopy});
  final CharacterCopy characterCopy;
  final RosterSlot slot;
}
