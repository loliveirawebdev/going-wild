import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/preparation_event.dart';

part 'no_match_preparation_state.dart';
part 'preparation_rejection.dart';
part 'ready_preparation_state.dart';

sealed class PreparationState {
  const PreparationState();
}
