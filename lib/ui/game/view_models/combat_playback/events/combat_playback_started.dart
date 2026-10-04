import 'package:going_wild/domain/models/combat_history/combat_history.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/events/combat_playback_event.dart';

class CombatPlaybackStarted extends CombatPlaybackEvent {
  const CombatPlaybackStarted({required this.combatHistory, required this.ticksPerSecond});
  final CombatHistory combatHistory;
  final int ticksPerSecond;

  @override
  String toString() => 'CombatPlaybackStarted(entries: ${combatHistory.entries.length}, ticksPerSecond: $ticksPerSecond)';
}
