import '../../models.dart';
import 'position.dart';

class Placement {
  const Placement({required this.character, required this.stars, required this.position});

  final int stars;
  final Position position;
  final Character character;
}
