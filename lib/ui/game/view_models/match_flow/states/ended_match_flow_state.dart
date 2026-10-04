part of 'match_flow_state.dart';

class EndedMatchFlowState extends MatchFlowState {
  const EndedMatchFlowState({required this.phaseStatus});
  final PhaseStatus phaseStatus;

  @override
  String toString() => 'EndedMatchFlowState(${phaseStatus.name})';
}
