import 'package:going_wild/domain/models/combat/combat_result.dart';
import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/match_progress/round_stage.dart';
import 'package:going_wild/domain/use_cases/round/fight_round.dart';

typedef StartedFight = ({MatchProgress fightingMatchProgress, CombatResult combatResult, MatchProgress matchProgressAfterFight});

RejectedPlayerActionError? checkStartingFight(MatchProgress matchProgress) => matchProgress.checkPreparingActions();

StartedFight startFight(MatchProgress matchProgress, {required bool recordsHistory}) {
  if (checkStartingFight(matchProgress) case final rejection?) throw rejection;
  final fought = fightRound(matchProgress, recordsHistory: recordsHistory);

  return (
    combatResult: fought.combatResult,
    matchProgressAfterFight: fought.matchProgress,
    fightingMatchProgress: matchProgress.createCopyWith(roundStage: RoundStage.fighting),
  );
}
