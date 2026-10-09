import 'dart:ui';

const effectHexagonSize = Size(148, 122);
const effectHexagonDrop = 10.0;

abstract final class EffectHexagon {
  static List<Offset> cornersAround(Offset center, double scale) {
    final halfWidth = effectHexagonSize.width * scale / 2;
    final halfHeight = effectHexagonSize.height * scale / 2;

    return [
      center + Offset(0, -halfHeight),
      center + Offset(halfWidth, -halfHeight / 2),
      center + Offset(halfWidth, halfHeight / 2),
      center + Offset(0, halfHeight),
      center + Offset(-halfWidth, halfHeight / 2),
      center + Offset(-halfWidth, -halfHeight / 2),
    ];
  }

  static Path pathAround(Offset center, double scale) => Path()..addPolygon(cornersAround(center, scale), true);

  static Offset edgePointAround(Offset center, double scale, double turn) {
    final corners = cornersAround(center, scale);
    final edgePosition = (turn % 1) * corners.length;
    final edgeIndex = edgePosition.floor();

    return Offset.lerp(corners[edgeIndex], corners[(edgeIndex + 1) % corners.length], edgePosition - edgeIndex)!;
  }
}
