sealed class SpriteMovement {
  const SpriteMovement();
}

class WalkingMovement extends SpriteMovement {
  const WalkingMovement({this.swayDegrees = 5});
  final double swayDegrees;
}

class HoppingMovement extends SpriteMovement {
  const HoppingMovement();
}

class FlyingMovement extends SpriteMovement {
  const FlyingMovement();
}
