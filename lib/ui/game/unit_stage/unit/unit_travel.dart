import 'dart:math';
import 'dart:ui';

class UnitTravel {
  UnitTravel({required this.from, required this.to, required this.ticks, required this.isWalking});

  final Offset from;
  final Offset to;
  final double ticks;
  final bool isWalking;

  double elapsedTicks = 0;

  double get progress => ticks <= 0 ? 1 : min(1, elapsedTicks / ticks);
  bool get hasArrived => progress >= 1;
}
