part of 'phase_event.dart';

class CharactersMerged extends PhaseEvent {
  const CharactersMerged({required super.roundNumber, required this.character, required this.newStars, required this.slot});

  final int newStars;
  final TeamSlot slot;
  final Character character;
}
