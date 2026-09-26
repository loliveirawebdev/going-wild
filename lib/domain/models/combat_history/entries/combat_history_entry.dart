import '../../board/position.dart';
import '../../combatant/combat_effects/base/lasting/combat_lasting_effect.dart';
import '../../combatant/faction.dart';

part 'ability_cast_history_entry.dart';
part 'attack_landed_history_entry.dart';
part 'combat_ended_history_entry.dart';
part 'combat_started_history_entry.dart';
part 'damage_taken_history_entry.dart';
part 'death_history_entry.dart';
part 'heal_received_history_entry.dart';
part 'lasting_effect_ended_history_entry.dart';
part 'lasting_effect_started_history_entry.dart';
part 'mana_received_history_entry.dart';
part 'movement_history_entry.dart';
part 'target_acquired_history_entry.dart';

sealed class CombatHistoryEntry {
  const CombatHistoryEntry({required this.tick});
  final int tick;
}
