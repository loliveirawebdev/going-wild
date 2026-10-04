import 'package:going_wild/ui/game/view_models/combat_playback/combat_playback_speed.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/events/combat_playback_event.dart';

class CombatPlaybackSpeedChanged extends CombatPlaybackEvent {
  const CombatPlaybackSpeedChanged({required this.speed});
  final CombatPlaybackSpeed speed;

  @override
  String toString() => 'CombatPlaybackSpeedChanged(${speed.name})';
}
