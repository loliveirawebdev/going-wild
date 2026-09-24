part of 'phase_event.dart';

class CharactersMerged extends PhaseEvent {
  const CharactersMerged({required super.roundNumber, required this.character, required this.newStars});

  final int newStars;
  final Character character;
}
