import 'package:going_wild/domain/models/phase/phase.dart';
import 'package:going_wild/ui/game/view_models/match_flow/events/match_flow_event.dart';

class MatchStarted extends MatchFlowEvent {
  final Phase phase;
  const MatchStarted({required this.phase});

  @override
  String toString() => 'MatchStarted(phase: ${phase.id.value})';
}
