part of 'phase_event.dart';

class PlayerReceivedCoins extends PhaseEvent {
  const PlayerReceivedCoins({required super.roundNumber, required this.amount, required this.coinsAfterReceived});

  final int amount;
  final int coinsAfterReceived;
}
