part of 'match_flow_state.dart';

class ShowingRoundResultMatchFlowState extends MatchFlowState {
  const ShowingRoundResultMatchFlowState({required this.roundResult, required this.matchProgressAfterFight});

  final RoundResult roundResult;
  final MatchProgress matchProgressAfterFight;

  @override
  String toString() => 'ShowingRoundResultMatchFlowState(victory: ${roundResult.isVictory})';
}
