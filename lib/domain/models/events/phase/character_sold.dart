part of 'phase_event.dart';

class CharacterSold extends PhaseEvent {
  const CharacterSold({
    required super.roundNumber,
    required this.character,
    required this.stars,
    required this.slot,
    required this.coinsReceived,
  });

  final int stars;
  final TeamSlot slot;
  final int coinsReceived;
  final Character character;
}
