import 'dart:math';

const _idleColumn = 0;
const _strideColumn = 1;
const _stretchColumn = 2;
const _stepColumn = 3;
const _attackColumn = 4;
const _abilityColumn = 5;

const _walkColumns = [0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3];
const _hopTakeOff = 0.3;
const _hopLanding = 0.72;
const _hopHeight = 16.0;
const _hopScale = 0.85;

const attackTicks = 24;
const abilityTicks = 20;
const releaseTick = 8;
const attackLeadInTicks = 4;

typedef PoseLayer = ({int column, double opacity});

class UnitPose {
  const UnitPose(this.layers, {this.advance = 0, this.lift = 0, this.scale = 1, this.tiltDegrees = 0});

  final List<PoseLayer> layers;
  final double advance;
  final double lift;
  final double scale;
  final double tiltDegrees;

  static const idle = UnitPose([(column: _idleColumn, opacity: 1)]);

  static UnitPose walking(double ticks, {required double swayDegrees}) => UnitPose(
    [(column: _walkColumns[ticks.floor() % _walkColumns.length], opacity: 1)],
    tiltDegrees: sin(2 * pi * ticks / _walkColumns.length) * swayDegrees,
  );

  static UnitPose hopping(double strideProgress) {
    if (!_isAirborne(strideProgress)) return idle;

    return UnitPose(
      const [(column: _stretchColumn, opacity: 1)],
      scale: _hopScale,
      lift: sin(pi * _airProgressOf(strideProgress)) * _hopHeight,
    );
  }

  static double hopTravelOf(double strideProgress) {
    if (strideProgress <= _hopTakeOff) return 0;
    if (strideProgress >= _hopLanding) return 1;

    final airProgress = _airProgressOf(strideProgress);
    return 1 - (1 - airProgress) * (1 - airProgress);
  }

  static UnitPose attacking(double ticks) => switch (ticks.floor()) {
    <= 3 => idle,
    <= 5 => const UnitPose([(column: _strideColumn, opacity: 1)]),
    6 => const UnitPose([(column: _strideColumn, opacity: 0.4), (column: _attackColumn, opacity: 0.6)]),
    7 => const UnitPose([(column: _attackColumn, opacity: 1)]),
    8 => const UnitPose([(column: _attackColumn, opacity: 1)], advance: 0.6),
    <= 10 => const UnitPose([(column: _stepColumn, opacity: 1)], advance: 1),
    11 => const UnitPose([(column: _stepColumn, opacity: 1)], advance: 0.5),
    12 => const UnitPose([(column: _stepColumn, opacity: 1)]),
    _ => idle,
  };

  static UnitPose castingAbility(double ticks) => switch (ticks.floor()) {
    0 => _abilityBlend(0.35),
    1 => _abilityBlend(0.7),
    <= 13 => const UnitPose([(column: _abilityColumn, opacity: 1)]),
    14 => _abilityBlend(0.7),
    15 => _abilityBlend(0.35),
    _ => idle,
  };

  static UnitPose _abilityBlend(double abilityOpacity) => UnitPose([
    (column: _idleColumn, opacity: 1 - abilityOpacity),
    (column: _abilityColumn, opacity: abilityOpacity),
  ]);

  static bool _isAirborne(double strideProgress) => strideProgress > _hopTakeOff && strideProgress < _hopLanding;
  static double _airProgressOf(double strideProgress) => (strideProgress - _hopTakeOff) / (_hopLanding - _hopTakeOff);

  static bool isAbilityColumn(int column) => column == _abilityColumn;
}
