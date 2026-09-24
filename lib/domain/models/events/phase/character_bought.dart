part of 'phase_event.dart';

class CharacterBought extends PhaseEvent {
  const CharacterBought({required super.roundNumber, required this.character, required this.offerIndex, required this.coinsSpent});

  final int offerIndex;
  final int coinsSpent;
  final Character character;
}
