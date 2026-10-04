import 'package:going_wild/domain/models/board/position.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';

class Placement {
  const Placement({required this.position, required this.characterCopy});

  final Position position;
  final CharacterCopy characterCopy;
}
