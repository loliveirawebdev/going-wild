part of 'match_flow_state.dart';

class FightingMatchFlowState extends MatchFlowState {
  const FightingMatchFlowState({
    required this.combatResult,
    required this.matchProgressAfterFight,
    required this.matchProgressBeforeFight,
  });

  final CombatResult combatResult;
  final MatchProgress matchProgressAfterFight;
  final MatchProgress matchProgressBeforeFight;

  @override
  String toString() => 'FightingMatchFlowState(winner: ${combatResult.winningFaction?.name ?? 'draw'})';
}
