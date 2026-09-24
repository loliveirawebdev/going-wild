import '../../models/combat/board/faction.dart';
import '../../models/combat/board/placement.dart';
import '../../models/events/phase/phase_event.dart';
import '../../models/phase/phase_run.dart';
import '../../models/phase/phase_status.dart';
import '../../models/phase/round_result.dart';
import '../combat/run_battle.dart';
import 'are_team_placements_valid.dart';
import 'start_round.dart';

RoundResult? fightRound(PhaseRun phaseRun, List<Placement> teamPlacements) {
  if (!areTeamPlacementsValid(phaseRun, teamPlacements)) return null;

  final rules = phaseRun.rules;

  final battleResult = runBattle(
    team: teamPlacements,
    enemies: phaseRun.currentEnemyWave.enemies,
    board: rules.board,
    rules: rules.battleRules,
    baseStats: rules.baseStats,
    sets: rules.sets,
    mergeCurveFor: rules.mergeCurveFor,
    randomGenerator: phaseRun.randomGenerator,
  );

  final foughtRoundNumber = phaseRun.currentRoundNumber;
  final survivingEnemyCount = battleResult.survivingUnits.where((unit) => unit.faction == Faction.enemy).length;
  final livesTaken = survivingEnemyCount < phaseRun.remainingLives ? survivingEnemyCount : phaseRun.remainingLives;
  final roundResult = RoundResult(roundNumber: foughtRoundNumber, livesTaken: livesTaken, battleResult: battleResult);

  phaseRun.remainingLives -= livesTaken;
  if (livesTaken > 0) {
    phaseRun.recordEvent(
      PlayerLivesLost(
        roundNumber: foughtRoundNumber,
        amount: livesTaken,
        remainingPlayerLives: phaseRun.remainingLives,
      ),
    );
  }

  if (phaseRun.remainingLives == 0) {
    phaseRun.status = PhaseStatus.lost;
    phaseRun.recordEvent(PhaseLost(roundNumber: foughtRoundNumber));
    return roundResult;
  }

  if (foughtRoundNumber == phaseRun.phase.roundCount) {
    phaseRun.status = PhaseStatus.won;
    phaseRun.recordEvent(PhaseWon(roundNumber: foughtRoundNumber));
    return roundResult;
  }

  phaseRun.currentRoundNumber += 1;
  startRound(phaseRun);
  return roundResult;
}
