import 'package:going_wild/domain/models/combat/combat.dart';
import 'package:going_wild/domain/models/combat/combat_in_progress.dart';
import 'package:going_wild/domain/models/combat_history/combat_history.dart';
import 'package:going_wild/domain/models/combat_history/combat_history_step.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';
import 'package:meta/meta.dart';

final _emptyHistory = CombatHistory(entries: const []);

class CombatWithoutHistory extends CombatInProgress {
  const CombatWithoutHistory({required super.combat});

  @override
  CombatHistory get history => _emptyHistory;

  @override
  @useResult
  CombatWithoutHistory createCopyWithCombat(Combat combat) => CombatWithoutHistory(combat: combat);

  @override
  @useResult
  CombatWithoutHistory createCopyAfterStep({required CombatHistoryStep step, required Combat Function(Combat combat) action}) =>
      CombatWithoutHistory(combat: action(combat));

  @override
  @useResult
  CombatHistory createHistoryEndedWith({required Faction? winningFaction}) => _emptyHistory;
}
