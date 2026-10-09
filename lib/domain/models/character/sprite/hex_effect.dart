import 'package:going_wild/domain/models/character/sprite/sprite_color.dart';

enum HexEffectTarget { self, allies, enemies }

enum HexEffectScope { target, targetAndNeighbors, all }

enum HexEffectKind { neon, inner, paint, mist, aura, pulse }

class HexEffect {
  const HexEffect({
    required this.kind,
    required this.color,
    required this.targets,
    required this.scope,
    required this.intensity,
    required this.tintsUnit,
    this.duration = const Duration(seconds: 3),
  });

  final HexEffectKind kind;
  final SpriteColor color;
  final Set<HexEffectTarget> targets;
  final HexEffectScope scope;
  final double intensity;
  final bool tintsUnit;
  final Duration duration;
}
