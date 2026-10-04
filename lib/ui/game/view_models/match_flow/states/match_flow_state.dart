import 'package:going_wild/domain/models/combat/combat_result.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/phase/phase_status.dart';

part 'ended_match_flow_state.dart';
part 'fighting_match_flow_state.dart';
part 'not_started_match_flow_state.dart';
part 'preparing_match_flow_state.dart';

sealed class MatchFlowState {
  const MatchFlowState();
}
