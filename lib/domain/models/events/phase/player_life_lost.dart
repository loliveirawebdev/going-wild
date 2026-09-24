part of 'phase_event.dart';

class PlayerLifeLost extends PhaseEvent {
  const PlayerLifeLost({required super.roundNumber, required this.remainingPlayerLives});

  final int remainingPlayerLives;
}
