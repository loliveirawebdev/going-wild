import 'board/faction.dart';
import '../events/combat/battle_event.dart';
import 'unit/unit.dart';

class BattleResult {
  const BattleResult({
    required this.events,
    required this.winningFaction,
    required this.elapsedSeconds,
    required this.survivingUnits,
  });

  final double elapsedSeconds;
  final Faction? winningFaction;
  final List<BattleEvent> events;
  final List<Unit> survivingUnits;
  bool get isDraw => winningFaction == null;
}
