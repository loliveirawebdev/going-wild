import 'dart:ui';

import 'package:going_wild/ui/core/design/app_shadows.dart';

const _compactSlotHeight = 54.0;
const _compactSlotSpacing = 3.0;
const _compactShopGap = 5.0;
const _compactShopDiameter = 48.0;
const _expandedColumnCount = 4;
const _expandedSlotHeight = 72.0;
const _expandedSpacing = 5.0;
const _expandedShopRadius = 8.0;

class BenchLayout {
  final double width;
  final int slotCount;
  final double expansion;
  const BenchLayout({required this.width, required this.expansion, required this.slotCount});

  int get _expandedRowCount => ((slotCount + 1) / _expandedColumnCount).ceil();
  double get _expandedHeight => _expandedRowCount * _expandedSlotHeight + (_expandedRowCount - 1) * _expandedSpacing;
  double get _compactSlotWidth => (width - _compactShopDiameter - _compactShopGap - (slotCount - 1) * _compactSlotSpacing) / slotCount;
  double get _expandedCellWidth => (width - (_expandedColumnCount - 1) * _expandedSpacing) / _expandedColumnCount;

  double get height => lerpDouble(_compactSlotHeight, _expandedHeight, expansion)!;
  double get shopRadius => lerpDouble(_compactShopDiameter / 2, _expandedShopRadius, expansion)!;
  double get nameOpacity => ((expansion - 0.5) * 2).clamp(0, 1);

  Rect slotRectOf(int slotIndex) => Rect.lerp(_compactSlotRectOf(slotIndex), _expandedCellRectOf(slotIndex), expansion)!;
  Rect get shopRect => Rect.lerp(_compactShopRect, _expandedCellRectOf(slotCount), expansion)!;

  Rect _compactSlotRectOf(int slotIndex) {
    final left = slotIndex * (_compactSlotWidth + _compactSlotSpacing);
    return Rect.fromLTWH(left, 0, _compactSlotWidth, _compactSlotHeight);
  }

  Rect get _compactShopRect {
    const shopHeight = _compactShopDiameter + AppShadows.pressOffset;
    return Rect.fromLTWH(width - _compactShopDiameter, (_compactSlotHeight - shopHeight) / 2, _compactShopDiameter, shopHeight);
  }

  Rect _expandedCellRectOf(int cellIndex) {
    final row = cellIndex ~/ _expandedColumnCount;
    final column = cellIndex % _expandedColumnCount;

    return Rect.fromLTWH(
      column * (_expandedCellWidth + _expandedSpacing),
      row * (_expandedSlotHeight + _expandedSpacing),
      _expandedCellWidth,
      _expandedSlotHeight,
    );
  }
}
