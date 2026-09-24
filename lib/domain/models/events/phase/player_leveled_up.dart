part of 'phase_event.dart';

class PlayerLeveledUp extends PhaseEvent {
  const PlayerLeveledUp({required super.roundNumber, required this.newLevel});

  final int newLevel;
}
