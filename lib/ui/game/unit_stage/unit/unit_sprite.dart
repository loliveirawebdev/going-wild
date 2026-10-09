import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/character/sprite/character_sprite.dart';
import 'package:going_wild/domain/models/character/sprite/sprite_movement.dart';
import 'package:going_wild/ui/game/unit_stage/sprite_ticks.dart';
import 'package:going_wild/ui/game/unit_stage/unit/unit_activity.dart';
import 'package:going_wild/ui/game/unit_stage/unit/unit_atlas.dart';
import 'package:going_wild/ui/game/unit_stage/unit/unit_direction.dart';
import 'package:going_wild/ui/game/unit_stage/unit/unit_light.dart';
import 'package:going_wild/ui/game/unit_stage/unit/unit_pose.dart';
import 'package:going_wild/ui/game/unit_stage/unit/unit_shadow.dart';
import 'package:going_wild/ui/game/unit_stage/unit/unit_travel.dart';

const footDrop = 18.0;

const _meleeReach = 22.0;
const _rangedReach = 8.0;
const _hopStrideTicks = 26.0;
const _ghostRow = 4;

const flightHeight = 24.0;
const _flightSwing = 7.0;
const _flightPace = 5.5;

const _poofTicks = 14.0;
const _poofBubbleCount = 7;
const _poofLift = 50.0;
const _poofColor = Color(0xFFF3F1EA);

const _ghostDelayTicks = 5.0;
const _ghostRiseTicks = 70.0;
const _ghostRise = 90.0;
const _ghostSway = 12.0;
const _ghostSwayPace = 0.18;

const _lightGround = 10.0;
const _lightReach = 110.0;
const _lightOpacity = 0.42;
const _auraLightOpacity = 0.35;
const _auraBlurSigma = 11.0;
const _auraSpread = [Offset(-3, 0), Offset(3, 0), Offset(0, -3), Offset(0, 3)];
const _layerMargin = 40.0;

class UnitSprite extends PositionComponent {
  UnitSprite({required this.character, required this.isRanged, required this.facing, required super.position})
    : prefersFrontView = facing.isFrontView;

  final bool isRanged;
  final Character character;
  final bool prefersFrontView;

  UnitDirection facing;

  late final UnitAtlas _atlas;
  late final shadow = UnitShadow(unit: this);

  UnitTravel? _travel;
  Offset _strikeHeading = Offset.zero;
  UnitActivity _activity = const RestingActivity();
  double _activityTicks = 0;
  double _lifeSeconds = 0;

  final _lights = <Object, UnitLight>{};
  final _opacities = <Object, double>{};
  final _displacements = <Object, Offset>{};
  final _cellPaint = Paint()..filterQuality = FilterQuality.medium;

  CharacterSprite get sprite => character.sprite;
  double get drawScale => atlasToBoardScale * sprite.boardScale;
  bool get isDying => _activity is DyingActivity;
  Offset get destination => _travel?.to ?? position.toOffset();

  Offset get stagePoint => position.toOffset() + _displacement;
  double get footY => stagePoint.dy + footDrop;
  double get headTopY => stagePoint.dy - _atlas.headHeightAboveAnchor * drawScale;
  double get heightAboveFoot => footY - headTopY;
  double get opacity => _opacities.values.fold(1, (product, opacity) => product * opacity);

  double get groundOpacity {
    if (!isDying) return opacity;
    return max(0, 1 - _activityTicks / _poofTicks);
  }

  Offset get _displacement => _displacements.values.fold(Offset.zero, (sum, displacement) => sum + displacement);
  double get _flightBob => sprite.movement is FlyingMovement ? -flightHeight + _flightSwing * sin(_lifeSeconds * _flightPace) : 0;

  @override
  FutureOr<void> onLoad() {
    if (UnitAtlas.loadedFor(sprite) case final loadedAtlas?) {
      _atlas = loadedAtlas;
      return null;
    }

    return UnitAtlas.of(sprite).then((atlas) => _atlas = atlas);
  }

  @override
  void onRemove() {
    shadow.removeFromParent();
    super.onRemove();
  }

  void rest() => _start(const RestingActivity());

  void walkInPlace() => _start(const WalkingInPlaceActivity());

  void castAbility() => _start(const CastingAbilityActivity());

  void die() {
    _travel = null;
    _start(const DyingActivity());
  }

  void teleportTo(Vector2 destination) {
    _travel = null;
    position.setFrom(destination);
  }

  void walkTo(Vector2 destination, {required double seconds}) {
    final from = position.toOffset();
    final to = destination.toOffset();
    facing = UnitDirection.diagonalToward(to - from);
    _travel = UnitTravel(from: from, to: to, ticks: spriteTicksIn(seconds), isWalking: true);
  }

  void slideTo(Vector2 destination, {required double seconds}) {
    _travel = UnitTravel(from: position.toOffset(), to: destination.toOffset(), ticks: spriteTicksIn(seconds), isWalking: false);
  }

  void attack(Offset targetPoint, {VoidCallback? onRelease}) {
    final delta = targetPoint - stagePoint;
    faceToward(targetPoint);
    _strikeHeading = UnitDirection.isLevel(delta) ? Offset(delta.dx.sign, 0) : facing.advance;
    _start(AttackingActivity(onRelease: onRelease));
  }

  void faceToward(Offset point) => facing = UnitDirection.toward(point - stagePoint, prefersFrontView: prefersFrontView);

  void keepEyeOn(Offset point) {
    if (_activity is RestingActivity && _travel == null) faceToward(point);
  }

  void displace(Object owner, Offset displacement) => _displacements[owner] = displacement;
  void fade(Object owner, double opacity) => _opacities[owner] = opacity;
  void light(Object owner, UnitLight light) => _lights[owner] = light;

  void release(Object owner) {
    _lights.remove(owner);
    _opacities.remove(owner);
    _displacements.remove(owner);
  }

  void paintFigure(Canvas canvas, Offset origin, {required UnitPose pose, required double opacity, ColorFilter? colorFilter}) {
    _cellPaint.colorFilter = colorFilter;

    canvas.save();
    canvas.translate(origin.dx, origin.dy - pose.lift);
    if (pose.tiltDegrees != 0) canvas.rotate(pose.tiltDegrees * pi / 180);
    canvas.scale(drawScale * pose.scale);

    for (final layer in pose.layers) {
      final keepsUnmirrored = UnitPose.isAbilityColumn(layer.column) && !sprite.mirrorsAbilityPose;
      _paintCell(
        canvas,
        row: facing.atlasRow,
        column: layer.column,
        opacity: layer.opacity * opacity,
        isMirrored: facing.isMirrored && !keepsUnmirrored,
      );
    }

    canvas.restore();
    _cellPaint.colorFilter = null;
  }

  UnitPose walkingPoseAt(double ticks) => _stridePose(ticks, strideProgress: (ticks % _hopStrideTicks) / _hopStrideTicks);

  @override
  void update(double dt) {
    _lifeSeconds += dt;
    _activityTicks += spriteTicksIn(dt);

    final activity = _activity;
    if (_travel case final travel?) _advance(travel, byTicks: spriteTicksIn(dt));
    if (activity is AttackingActivity && !activity.hasReleased && _activityTicks >= releaseTick) {
      activity.hasReleased = true;
      activity.onRelease?.call();
    }

    final duration = activity.durationInTicks;
    if (duration != null && _activityTicks >= duration) _finish(activity);

    priority = stagePoint.dy.round() * 2;
  }

  @override
  void render(Canvas canvas) {
    if (isDying) return _renderDeath(canvas);

    final opacity = this.opacity;
    if (opacity <= 0) return;

    final pose = _currentPose;
    final origin = _bodyOriginFor(pose);
    final bounds = _boundsAround(origin);
    final activeLights = [
      for (final light in _lights.values)
        if (light.intensity > 0) light,
    ];

    for (final light in activeLights.where((light) => light.isAura)) {
      _renderAura(canvas, light, origin: origin, pose: pose, bounds: bounds);
    }

    final tintingLights = activeLights.where((light) => light.tintsUnit).toList();
    if (tintingLights.isEmpty) return paintFigure(canvas, origin, pose: pose, opacity: opacity);

    canvas.saveLayer(bounds, Paint());
    paintFigure(canvas, origin, pose: pose, opacity: opacity);
    for (final light in tintingLights) {
      canvas.drawRect(bounds, _tintPaintOf(light, origin: origin));
    }
    canvas.restore();
  }

  void _start(UnitActivity activity) {
    _activity = activity;
    _activityTicks = 0;
  }

  void _finish(UnitActivity activity) {
    if (activity is DyingActivity) return removeFromParent();
    rest();
  }

  void _advance(UnitTravel travel, {required double byTicks}) {
    travel.elapsedTicks += byTicks;
    final progress = travel.progress;
    final traveled = switch ((travel.isWalking, sprite.movement)) {
      (false, _) => 1 - (1 - progress) * (1 - progress),
      (true, HoppingMovement()) => UnitPose.hopTravelOf(progress),
      (true, _) => progress,
    };

    final current = Offset.lerp(travel.from, travel.to, traveled)!;
    position.setValues(current.dx, current.dy);
    if (travel.hasArrived) _travel = null;
  }

  UnitPose get _currentPose => switch ((_activity, _travel)) {
    (RestingActivity(), UnitTravel(isWalking: true) && final travel) => _stridePose(travel.elapsedTicks, strideProgress: travel.progress),
    (AttackingActivity(), UnitTravel(isWalking: true) && final travel) when _activityTicks < attackLeadInTicks => _stridePose(
      travel.elapsedTicks,
      strideProgress: travel.progress,
    ),
    (RestingActivity() || DyingActivity(), _) => UnitPose.idle,
    (WalkingInPlaceActivity(), _) => walkingPoseAt(_activityTicks),
    (AttackingActivity(), _) => UnitPose.attacking(_activityTicks),
    (CastingAbilityActivity(), _) => UnitPose.castingAbility(_activityTicks),
  };

  UnitPose _stridePose(double ticks, {required double strideProgress}) => switch (sprite.movement) {
    WalkingMovement(:final swayDegrees) => UnitPose.walking(ticks, swayDegrees: swayDegrees),
    HoppingMovement() => UnitPose.hopping(strideProgress),
    FlyingMovement() => UnitPose.idle,
  };

  Offset _bodyOriginFor(UnitPose pose) {
    final reach = isRanged ? _rangedReach : _meleeReach;
    return _displacement + _strikeHeading * (reach * pose.advance) + Offset(0, _flightBob);
  }

  Rect _boundsAround(Offset origin) {
    final cell = Offset.zero & atlasCellSize;
    return Rect.fromLTRB(
      origin.dx - atlasAnchor.dx * drawScale,
      origin.dy - atlasAnchor.dy * drawScale,
      origin.dx + (cell.width - atlasAnchor.dx) * drawScale,
      origin.dy + (cell.height - atlasAnchor.dy) * drawScale,
    ).inflate(_layerMargin);
  }

  void _paintCell(Canvas canvas, {required int row, required int column, required double opacity, required bool isMirrored}) {
    final frame = _atlas.frameAt(row: row, column: column);
    if (frame == null) return;

    _cellPaint.color = Color.fromRGBO(255, 255, 255, opacity.clamp(0, 1));

    canvas.save();
    if (isMirrored) canvas.scale(-1, 1);
    canvas.drawImageRect(_atlas.image, frame.source, frame.destination, _cellPaint);
    canvas.restore();
  }

  void _renderAura(Canvas canvas, UnitLight light, {required Offset origin, required UnitPose pose, required Rect bounds}) {
    final opacity = (0.55 + 0.25 * sin(light.seconds * 3)) * min(1, light.intensity);
    final silhouette = ColorFilter.mode(light.color, BlendMode.srcIn);

    canvas.saveLayer(bounds, Paint()..imageFilter = ImageFilter.blur(sigmaX: _auraBlurSigma, sigmaY: _auraBlurSigma));
    for (final spread in _auraSpread) {
      paintFigure(canvas, origin + spread, pose: pose, opacity: opacity, colorFilter: silhouette);
    }
    canvas.restore();

    for (final spread in _auraSpread) {
      paintFigure(canvas, origin + spread, pose: pose, opacity: opacity, colorFilter: silhouette);
    }
  }

  Paint _tintPaintOf(UnitLight light, {required Offset origin}) {
    final baseOpacity = light.isAura ? _auraLightOpacity : _lightOpacity;
    final opacity = (baseOpacity * light.intensity * (0.85 + 0.15 * sin(light.seconds * 3))).clamp(0.0, 1.0);

    return Paint()
      ..blendMode = BlendMode.srcATop
      ..shader = Gradient.linear(
        origin + const Offset(0, _lightGround),
        origin - const Offset(0, _lightReach),
        [light.color.withValues(alpha: opacity), light.color.withValues(alpha: 0)],
      );
  }

  void _renderDeath(Canvas canvas) {
    final ticks = _activityTicks;
    final origin = _displacement;

    if (ticks < _poofTicks) {
      final progress = ticks / _poofTicks;
      final spread = 20 + 60 * progress;
      final bubblePaint = Paint()..color = _poofColor.withValues(alpha: (1 - progress) * 0.85);

      for (var bubble = 0; bubble < _poofBubbleCount; bubble++) {
        final angle = bubble / _poofBubbleCount * 2 * pi;
        final center = origin + Offset(cos(angle) * spread * 0.7, -_poofLift + sin(angle) * spread * 0.45);
        canvas.drawCircle(center, 22 - 10 * progress, bubblePaint);
      }
    }

    if (ticks < _ghostDelayTicks) return;

    final rise = min(1.0, (ticks - _ghostDelayTicks) / _ghostRiseTicks);
    canvas.save();
    canvas.translate(origin.dx + sin(ticks * _ghostSwayPace) * _ghostSway, origin.dy - _ghostRise * rise);
    canvas.scale(drawScale);
    _paintCell(canvas, row: _ghostRow, column: 0, opacity: 1 - rise * rise, isMirrored: false);
    canvas.restore();
  }
}
