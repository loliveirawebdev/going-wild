import 'package:going_wild/domain/models/character/sprite/sprite_color.dart';

enum ProjectileVariant { fire, rock, web, beam }

sealed class ActionEffect {
  const ActionEffect({required this.color});
  final SpriteColor color;
}

class StunActionEffect extends ActionEffect {
  const StunActionEffect({required super.color});
}

class PushActionEffect extends ActionEffect {
  const PushActionEffect({required super.color});
}

class DashActionEffect extends ActionEffect {
  const DashActionEffect({required super.color});
}

class ProjectileActionEffect extends ActionEffect {
  const ProjectileActionEffect({required super.color, required this.variant});
  final ProjectileVariant variant;
}

class VanishActionEffect extends ActionEffect {
  const VanishActionEffect({required super.color});
}
