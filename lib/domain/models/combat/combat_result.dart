import '../combatant/combatant.dart';
import '../combatant/faction.dart';
import '../combat_history/combat_history.dart';

class CombatResult {
  const CombatResult({
    required this.history,
    required this.combatants,
    required this.winningFaction,
    required this.elapsedSeconds,
  });

  final double elapsedSeconds;
  final Faction? winningFaction;
  final List<Combatant> combatants;
  final CombatHistory history;

  bool get isDraw => winningFaction == null;
  bool get isLost => winningFaction != Faction.team;
  List<Combatant> get survivingCombatants => combatants.where((combatant) => combatant.isAlive).toList();
}
