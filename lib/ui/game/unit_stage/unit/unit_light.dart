import 'dart:ui';

import 'package:going_wild/domain/models/character/sprite/hex_effect.dart';

class UnitLight {
  UnitLight({required this.kind, required this.color, required this.tintsUnit});

  final Color color;
  final bool tintsUnit;
  final HexEffectKind kind;

  double seconds = 0;
  double intensity = 0;

  bool get isAura => kind == HexEffectKind.aura;
}
