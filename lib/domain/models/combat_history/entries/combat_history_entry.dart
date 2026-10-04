import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/combat_history/causes/combat_history_cause.dart';
import 'package:going_wild/domain/models/combat_history/combat_history_step_kind.dart';
import 'package:going_wild/domain/models/combat_history/comparison/combat_step_comparison.dart';
import 'package:going_wild/domain/models/combat_history/comparison/combatant_step_comparison.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay_combatant.dart';
import 'package:going_wild/domain/models/combatant/combat_effects/base/lasting/combat_lasting_effect.dart';
import 'package:going_wild/domain/models/combatant/combatant.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';

part 'ability_cast_history_entry.dart';
part 'attack_landed_history_entry.dart';
part 'combat_ended_history_entry.dart';
part 'combat_started_history_entry.dart';
part 'damage_taken_history_entry.dart';
part 'death_history_entry.dart';
part 'heal_received_history_entry.dart';
part 'lasting_effect_changed_history_entry.dart';
part 'lasting_effect_ended_history_entry.dart';
part 'lasting_effect_started_history_entry.dart';
part 'mana_received_history_entry.dart';
part 'mana_spent_history_entry.dart';
part 'movement_history_entry.dart';
part 'target_acquired_history_entry.dart';

sealed class CombatHistoryEntry {
  const CombatHistoryEntry({required this.tick});
  final int tick;

  List<CombatReplayCombatant> applyTo(List<CombatReplayCombatant> combatants) => combatants;
}

sealed class CombatConsequenceHistoryEntry extends CombatHistoryEntry {
  const CombatConsequenceHistoryEntry({required super.tick, required this.cause, required this.combatantId});
  final int combatantId;
  final CombatHistoryCause cause;

  CombatReplayCombatant applyToCombatant(CombatReplayCombatant combatant) => combatant;

  @override
  List<CombatReplayCombatant> applyTo(List<CombatReplayCombatant> combatants) => [
    for (final combatant in combatants) combatant.id == combatantId ? applyToCombatant(combatant) : combatant,
  ];
}
