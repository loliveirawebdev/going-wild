part of 'phase_event.dart';

class PlayerReceivedExperience extends PhaseEvent {
  const PlayerReceivedExperience({required super.roundNumber, required this.amount, required this.experienceAfterReceived});

  final int amount;
  final int experienceAfterReceived;
}
