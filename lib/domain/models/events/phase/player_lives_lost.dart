part of 'phase_event.dart';

class PlayerLivesLost extends PhaseEvent {
  const PlayerLivesLost({required super.roundNumber, required this.amount, required this.remainingPlayerLives});

  final int amount;
  final int remainingPlayerLives;
}
