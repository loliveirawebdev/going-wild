import 'dart:ui';

import 'package:going_wild/ui/game/unit_stage/unit/unit_pose.dart';

const deathTicks = 110;

sealed class UnitActivity {
  const UnitActivity();

  double? get durationInTicks => null;
}

class RestingActivity extends UnitActivity {
  const RestingActivity();
}

class WalkingInPlaceActivity extends UnitActivity {
  const WalkingInPlaceActivity();
}

class AttackingActivity extends UnitActivity {
  AttackingActivity({required this.onRelease});

  final VoidCallback? onRelease;
  bool hasReleased = false;

  @override
  double get durationInTicks => attackTicks.toDouble();
}

class CastingAbilityActivity extends UnitActivity {
  const CastingAbilityActivity();

  @override
  double get durationInTicks => abilityTicks.toDouble();
}

class DyingActivity extends UnitActivity {
  const DyingActivity();

  @override
  double get durationInTicks => deathTicks.toDouble();
}
