import 'package:going_wild/domain/models/combat_history/entries/combat_history_entry.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay_frame.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/combat_playback_speed.dart';
import 'package:meta/meta.dart';

part 'finished_combat_playback_state.dart';
part 'idle_combat_playback_state.dart';
part 'playing_combat_playback_state.dart';

sealed class CombatPlaybackState {
  final CombatPlaybackSpeed speed;
  const CombatPlaybackState({required this.speed});

  @useResult
  CombatPlaybackState createCopyWithSpeed(CombatPlaybackSpeed speed);
}
