import 'package:going_wild/domain/models/board/placement.dart';
import 'package:going_wild/domain/models/board/position.dart';

extension PlacementList on List<Placement> {
  Placement? placementAt(Position position) {
    for (final placement in this) {
      if (placement.position == position) {
        return placement;
      }
    }

    return null;
  }

  List<Placement> createCopyWithPlacement(Placement newPlacement) {
    final isOccupied = any((placement) => placement.position == newPlacement.position);
    if (!isOccupied) return List.unmodifiable([...this, newPlacement]);
    return List.unmodifiable([for (final placement in this) placement.position == newPlacement.position ? newPlacement : placement]);
  }

  List<Placement> createCopyWithoutPlacementAt(Position position) {
    return List.unmodifiable(
      where((placement) {
        final isPlacementPositionDifferentFromGivenPosition = placement.position != position;
        return isPlacementPositionDifferentFromGivenPosition;
      }),
    );
  }
}
