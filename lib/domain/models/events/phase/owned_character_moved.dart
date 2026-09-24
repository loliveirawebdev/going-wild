part of 'phase_event.dart';

class OwnedCharacterMoved extends PhaseEvent {
  const OwnedCharacterMoved({
    required super.roundNumber,
    required this.character,
    required this.stars,
    required this.from,
    required this.to,
  });

  final int stars;
  final TeamSlot to;
  final TeamSlot from;
  final Character character;
}
