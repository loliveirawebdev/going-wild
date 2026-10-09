import 'dart:math';
import 'dart:ui';

const _diagonalAngle = 0.9;
const _levelThreshold = 25.0;

enum UnitDirection {
  frontRight(atlasRow: 0, isMirrored: false, advance: Offset(1, 0.75), angle: _diagonalAngle),
  front(atlasRow: 1, isMirrored: false, advance: Offset(0, 1), angle: pi / 2),
  frontLeft(atlasRow: 0, isMirrored: true, advance: Offset(-1, 0.75), angle: pi - _diagonalAngle),
  backRight(atlasRow: 2, isMirrored: false, advance: Offset(1, -0.75), angle: -_diagonalAngle),
  back(atlasRow: 3, isMirrored: false, advance: Offset(0, -1), angle: -pi / 2),
  backLeft(atlasRow: 2, isMirrored: true, advance: Offset(-1, -0.75), angle: _diagonalAngle - pi);

  final int atlasRow;
  final bool isMirrored;
  final Offset advance;
  final double angle;
  const UnitDirection({required this.atlasRow, required this.isMirrored, required this.advance, required this.angle});

  bool get isFrontView => atlasRow <= front.atlasRow;

  static bool isLevel(Offset delta) => delta.dy.abs() < _levelThreshold;

  static UnitDirection toward(Offset delta, {required bool prefersFrontView}) {
    if (isLevel(delta)) return diagonalToward(Offset(delta.dx, prefersFrontView ? 1 : -1));

    final targetAngle = atan2(delta.dy, delta.dx);
    return values.reduce((closest, direction) {
      final isCloser = _angleBetween(targetAngle, direction.angle).abs() < _angleBetween(targetAngle, closest.angle).abs();
      return isCloser ? direction : closest;
    });
  }

  static UnitDirection diagonalToward(Offset delta) {
    if (delta.dy > 0) return delta.dx > 0 ? frontRight : frontLeft;
    return delta.dx > 0 ? backRight : backLeft;
  }

  static double _angleBetween(double angle, double reference) {
    final difference = (angle - reference) % (2 * pi);
    return difference > pi ? difference - 2 * pi : difference;
  }
}
