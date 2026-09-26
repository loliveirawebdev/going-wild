import '../position.dart';

class NoPlacementAtPositionError extends StateError {
  NoPlacementAtPositionError({required Position position}) : super('Nobody is placed at $position');
}
