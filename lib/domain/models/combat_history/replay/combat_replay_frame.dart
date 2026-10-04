import 'package:going_wild/domain/models/combat_history/replay/combat_replay_combatant.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';

class CombatReplayFrame {
  const CombatReplayFrame({required this.tick, required this.combatants});

  final int tick;
  final List<CombatReplayCombatant> combatants;

  List<CombatReplayCombatant> aliveCombatantsFromFaction(Faction faction) {
    final filteredCombatants = combatants.where((combatant) => combatant.faction == faction && combatant.isAlive);
    return filteredCombatants.toList();
  }

  @override
  String toString() => 'CombatReplayFrame(tick: $tick)';
}
