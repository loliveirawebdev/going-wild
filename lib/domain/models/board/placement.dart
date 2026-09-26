import '../character/character_copy.dart';
import 'position.dart';

class Placement {
  const Placement({required this.position, required this.characterCopy});

  final Position position;
  final CharacterCopy characterCopy;
}
