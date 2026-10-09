import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:going_wild/domain/models/character/sprite/ability_visuals.dart';
import 'package:going_wild/domain/models/character/sprite/action_effect.dart';
import 'package:going_wild/domain/models/character/sprite/hex_effect.dart';
import 'package:going_wild/domain/models/character/sprite/sprite_color.dart';
import 'package:going_wild/ui/game/unit_stage/effects/action/action_effect_painter.dart';
import 'package:going_wild/ui/game/unit_stage/effects/hex/effect_hexagon.dart';
import 'package:going_wild/ui/game/unit_stage/effects/hex/hex_effect_painter.dart';
import 'package:going_wild/ui/game/unit_stage/performance/ability_cast.dart';
import 'package:going_wild/ui/game/unit_stage/sprite_ticks.dart';
import 'package:going_wild/ui/game/unit_stage/stage_painting.dart';
import 'package:going_wild/ui/game/unit_stage/unit/unit_light.dart';
import 'package:going_wild/ui/game/unit_stage/unit/unit_sprite.dart';
import 'package:going_wild/ui/game/unit_stage/unit_stage.dart';

const _white = Color(0xFFFFFFFF);

const _hexEntrance = 0.6;
const _hexRise = 0.35;
const _hexFade = 0.5;
const _afterglow = 0.6;

const _impactAt = 0.6;
const _projectileImpactAt = 0.9;
const _vanishImpactAt = 1.25;
const _flashSeconds = 0.3;

const _stunDelay = 0.1;
const _stunRise = 0.2;
const _stunFade = 0.4;
const _stunLift = 4.0;

const _slideSeconds = 0.4;
const _dustSeconds = 0.45;
const _dustInterval = 0.05;
const _dustLifetime = 0.8;

const _dashStart = 0.3;
const _dashSeconds = 0.25;
const _dashReturnLead = 0.1;
const _dashReturnSeconds = 0.45;
const _dashStop = 70.0;
const _dashWalkUntil = 0.6;
const _dashReturnWalk = 0.4;
const _dashTrailCount = 5;
const _dashTrailSpacing = 0.045;

const _projectileStart = 0.35;
const _projectileFlight = 0.55;
const _beamSeconds = 0.8;
const _webGrowth = 0.25;
const _webFade = 0.4;
const _webDrop = 2.0;
const _projectileLead = 30.0;
const _casterHeightShare = 0.55;
const _targetHeightShare = 0.45;
const _fireArc = 25.0;
const _rockArc = 60.0;
const _fireTrailCount = 8;
const _fireTrailSpacing = 0.035;

const _vanishOut = 0.45;
const _vanishBack = 1.05;
const _vanishAppear = 0.2;
const _puffSeconds = 0.6;
const _vanishPuffAt = 0.3;
const _reappearPuffLead = 0.15;

class AbilityPerformance extends Component {
  AbilityPerformance({required this.cast, required this.stage});

  final UnitStage stage;
  final AbilityCast cast;

  final _random = Random();
  final _dust = <DustMote>[];
  final _paintings = <Component>[];
  final _lights = <UnitSprite, UnitLight>{};
  late final List<UnitSprite> _hexTargets = cast.hexTargets;
  late final List<UnitSprite> _struckUnits = cast.struckUnits;
  late final Offset _casterOrigin = cast.caster.stagePoint;
  late final Offset _targetOrigin = cast.target.stagePoint;
  late final HexEffectPainter? _hexPainter = switch (_hexEffect) {
    final hexEffect? => HexEffectPainter(kind: hexEffect.kind, color: _colorOf(hexEffect.color)),
    null => null,
  };

  double _seconds = 0;
  double _lastDustAt = double.negativeInfinity;
  Offset? _casterDestination;
  UnitSprite? _reappearanceFacingTarget;
  double? _casterReappearedAt;
  final _slidUnits = <UnitSprite>[];
  late final _pendingRelocations = {...cast.relocations};
  _DashStage _dashStage = _DashStage.charging;

  UnitSprite get _caster => cast.caster;
  UnitSprite get _target => cast.target;
  HexEffect? get _hexEffect => cast.hexEffect;
  List<ActionEffect> get _actionEffects => _caster.sprite.abilityVisuals.actionEffects;

  StunActionEffect? get _stun => _actionEffects.whereType<StunActionEffect>().firstOrNull;
  PushActionEffect? get _push => _actionEffects.whereType<PushActionEffect>().firstOrNull;
  DashActionEffect? get _dash => _actionEffects.whereType<DashActionEffect>().firstOrNull;
  VanishActionEffect? get _vanish => _actionEffects.whereType<VanishActionEffect>().firstOrNull;
  ProjectileActionEffect? get _projectile => _actionEffects.whereType<ProjectileActionEffect>().firstOrNull;

  double get _effectSeconds => _caster.sprite.abilityVisuals.effectDuration.inMicroseconds / Duration.microsecondsPerSecond;
  double get _endsAt => _hexEntrance + _effectSeconds;
  double get _impactsAt => _vanish != null ? _vanishImpactAt : (_projectile != null ? _projectileImpactAt : _impactAt);

  Offset get _heading {
    final delta = _targetOrigin - _casterOrigin;
    return delta.distance == 0 ? const Offset(0, -1) : delta / delta.distance;
  }

  static double secondsUntilEffectOf(AbilityVisuals visuals) {
    final actionEffects = visuals.actionEffects;
    if (actionEffects.any((effect) => effect is VanishActionEffect)) return _vanishOut;
    if (actionEffects.any((effect) => effect is ProjectileActionEffect)) return _projectileImpactAt;
    return _impactAt;
  }

  @override
  void onMount() {
    super.onMount();
    if (_caster != _target) _caster.faceToward(_targetOrigin);
    _dash == null ? _caster.castAbility() : _caster.walkInPlace();

    final hexEffect = _hexEffect;
    if (hexEffect != null) {
      for (final unit in _hexTargets) {
        final light = UnitLight(kind: hexEffect.kind, color: _colorOf(hexEffect.color), tintsUnit: hexEffect.tintsUnit);
        _lights[unit] = light;
        unit.light(this, light);
      }
    }

    _addPainting(stage.ground, StagePainting(_paintGround));
    for (final unit in _hexTargets) {
      _addPainting(stage.units, StagePainting((canvas) => _paintHexFront(canvas, unit), inFrontOf: unit));
    }
  }

  @override
  void onRemove() {
    for (final painting in _paintings) {
      painting.removeFromParent();
    }
    for (final unit in {_caster, ..._hexTargets, ..._struckUnits}) {
      unit.release(this);
    }
    super.onRemove();
  }

  @override
  void update(double dt) {
    _seconds += dt;

    final hexIntensity = _hexIntensity;
    for (final light in _lights.values) {
      light
        ..seconds = _seconds
        ..intensity = hexIntensity;
    }

    if (_dash != null) _moveDash();
    if (_vanish != null) _moveVanish();
    if (_push != null) _raiseDust();
    _relocateUnits();

    if (_seconds >= _endsAt + _afterglow) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    if (_vanish case final vanish?) _paintVanishPuffs(canvas, _colorOf(vanish.color));
    if (_push case final push?) ActionEffectPainter.paintDust(canvas, _dust, seconds: _seconds, color: _colorOf(push.color));
    if (_projectile case final projectile?) _paintProjectile(canvas, projectile);
    if (_stun case final stun?) _paintStun(canvas, _colorOf(stun.color));
    if (_actionEffects.isNotEmpty) _paintImpactFlash(canvas);
  }

  double get _hexIntensity {
    final hexEffect = _hexEffect;
    if (hexEffect == null) return 0;

    final shown = _seconds - _hexEntrance;
    final presence = switch (shown) {
      < 0 => 0.0,
      < _hexRise => shown / _hexRise,
      _ when shown > _effectSeconds => max(0.0, 1 - (shown - _effectSeconds) / _hexFade),
      _ => 1.0,
    };

    return hexEffect.intensity * presence;
  }

  void _addPainting(Component layer, Component painting) {
    _paintings.add(painting);
    layer.add(painting);
  }

  void _paintGround(Canvas canvas) {
    final hexPainter = _hexPainter;
    final intensity = _hexIntensity;
    if (hexPainter != null && intensity > 0) {
      for (final unit in _hexTargets) {
        hexPainter.paintGround(canvas, _hexCenterOf(unit), seconds: _seconds, intensity: intensity);
      }
    }

    if (_dash case final dash?) _paintDashTrail(canvas, _colorOf(dash.color));
  }

  void _paintHexFront(Canvas canvas, UnitSprite unit) {
    final intensity = _hexIntensity;
    if (intensity <= 0) return;
    _hexPainter?.paintFront(canvas, _hexCenterOf(unit), seconds: _seconds, intensity: intensity);
  }

  Offset _hexCenterOf(UnitSprite unit) => unit.position.toOffset() + const Offset(0, effectHexagonDrop);

  double _dashShareAt(double seconds) {
    final reach = _easeOut((seconds - _dashStart) / _dashSeconds);
    final comeback = _smoothStep((seconds - _endsAt + _dashReturnLead) / _dashReturnSeconds);
    return reach * (1 - comeback);
  }

  double get _dashDistance => max(0, (_targetOrigin - _casterOrigin).distance - _dashStop);

  void _moveDash() {
    _caster.displace(this, _heading * (_dashDistance * _dashShareAt(_seconds)));

    final nextStage = switch (_seconds) {
      < _dashWalkUntil => _DashStage.charging,
      _ when _seconds > _endsAt - _dashReturnLead && _seconds < _endsAt + _dashReturnWalk => _DashStage.returning,
      _ when _seconds >= _endsAt + _dashReturnWalk => _DashStage.done,
      _ => _DashStage.striking,
    };
    if (nextStage == _dashStage) return;

    _dashStage = nextStage;
    nextStage == _DashStage.returning ? _caster.walkInPlace() : _caster.rest();
  }

  void _paintDashTrail(Canvas canvas, Color color) {
    final share = _dashShareAt(_seconds);
    final tint = ColorFilter.mode(color, BlendMode.srcATop);
    final pose = _caster.walkingPoseAt(spriteTicksIn(_seconds));

    for (var copy = 1; copy <= _dashTrailCount; copy++) {
      final copyShare = _dashShareAt(_seconds - copy * _dashTrailSpacing);
      if ((copyShare - share).abs() <= 0.02) continue;

      final origin = _caster.position.toOffset() + _heading * (_dashDistance * copyShare);
      _caster.paintFigure(canvas, origin, pose: pose, opacity: (1 - copy / 6) * 0.45, colorFilter: tint);
    }
  }

  void relocate(UnitSprite unit, Offset destination, {UnitSprite? facingToward}) {
    _pendingRelocations[unit] = destination;
    if (unit == _caster && facingToward != null) _reappearanceFacingTarget = facingToward;
  }

  Iterable<UnitSprite> get _pushedUnits => _slidUnits.isEmpty ? _struckUnits : _slidUnits;

  void _moveVanish() {
    final seconds = _seconds;
    if (seconds <= _vanishOut) return;
    if (seconds < _vanishBack) return _caster.fade(this, 0);

    final destination = _pendingRelocations.remove(_caster);
    if (destination != null) {
      _casterDestination = destination;
      _casterReappearedAt = seconds;
      _caster
        ..teleportTo(Vector2(destination.dx, destination.dy))
        ..faceToward((_reappearanceFacingTarget ?? _target).destination);
    }

    final reappearedAt = _casterReappearedAt;
    _caster.fade(this, reappearedAt == null ? 0 : min(1, (seconds - reappearedAt) / _vanishAppear));
  }

  void _relocateUnits() {
    if (_seconds < _impactsAt) return;

    for (final MapEntry(key: unit, value: destination) in _pendingRelocations.entries.toList()) {
      if (unit == _caster && _vanish != null) continue;

      _pendingRelocations.remove(unit);
      _slidUnits.add(unit);
      unit.slideTo(Vector2(destination.dx, destination.dy), seconds: _slideSeconds);
    }
  }

  void _paintVanishPuffs(Canvas canvas, Color color) {
    final origin = _casterOrigin + const Offset(0, footDrop);
    ActionEffectPainter.paintSmokePuff(canvas, origin, progress: (_seconds - _vanishPuffAt) / _puffSeconds, color: color);

    final (destination, reappearedAt) = (_casterDestination, _casterReappearedAt);
    if (destination == null || reappearedAt == null) return;

    ActionEffectPainter.paintSmokePuff(
      canvas,
      destination + const Offset(0, footDrop),
      progress: (_seconds - reappearedAt + _reappearPuffLead) / _puffSeconds,
      color: color,
    );
  }

  void _raiseDust() {
    final seconds = _seconds;
    final isRaisingDust = seconds > _impactsAt && seconds < _impactsAt + _dustSeconds;

    if (isRaisingDust && seconds - _lastDustAt > _dustInterval) {
      _lastDustAt = seconds;
      for (final unit in _pushedUnits) {
        _dust.add((
          bornAt: seconds,
          origin: unit.stagePoint + const Offset(0, footDrop),
          drift: (_random.nextDouble() - 0.5) * 20,
          size: 0.7 + _random.nextDouble() * 0.6,
        ));
      }
    }

    _dust.removeWhere((mote) => seconds - mote.bornAt >= _dustLifetime);
  }

  void _paintProjectile(Canvas canvas, ProjectileActionEffect projectile) {
    final color = _colorOf(projectile.color);
    final from = Offset(
      _caster.stagePoint.dx + _heading.dx * _projectileLead,
      _caster.footY - _caster.heightAboveFoot * _casterHeightShare,
    );
    final to = Offset(_target.stagePoint.dx, _target.footY - _target.heightAboveFoot * _targetHeightShare);

    if (projectile.variant == ProjectileVariant.beam) {
      return ActionEffectPainter.paintBeam(canvas, from, to, progress: (_seconds - _projectileStart) / _beamSeconds, color: color);
    }

    final arc = projectile.variant == ProjectileVariant.rock ? _rockArc : _fireArc;
    Offset pointAt(double flight) => Offset.lerp(from, to, flight)! - Offset(0, arc * sin(flight * pi));

    final flight = (_seconds - _projectileStart) / _projectileFlight;
    if (flight >= 0 && flight <= 1) {
      switch (projectile.variant) {
        case ProjectileVariant.fire:
          ActionEffectPainter.paintFireBall(
            canvas,
            pointAt(flight),
            color: color,
            trail: [
              for (var spot = 1; spot <= _fireTrailCount && flight - spot * _fireTrailSpacing >= 0; spot++)
                (center: pointAt(flight - spot * _fireTrailSpacing), radius: 12.0 - spot, opacity: 1 - spot / 9),
            ],
          );
        case ProjectileVariant.rock:
          ActionEffectPainter.paintSpinningRock(canvas, pointAt(flight), seconds: _seconds, color: color);
        case ProjectileVariant.web:
          ActionEffectPainter.paintWebPellet(canvas, pointAt(flight), color: color);
        case ProjectileVariant.beam:
          break;
      }
    }

    if (projectile.variant == ProjectileVariant.web) {
      ActionEffectPainter.paintWeb(
        canvas,
        _target.stagePoint - const Offset(0, _webDrop),
        color: color,
        progress: (_seconds - _impactsAt) / _webGrowth,
        opacity: _lingeringOpacity(startsAt: _impactsAt, fadeSeconds: _webFade),
      );
    }
  }

  double _lingeringOpacity({required double startsAt, required double fadeSeconds, double riseSeconds = 0}) {
    final seconds = _seconds;
    if (seconds < startsAt) return 0;
    if (seconds > _endsAt) return max(0, 1 - (seconds - _endsAt) / fadeSeconds);
    return riseSeconds == 0 ? 1 : min(1, (seconds - startsAt) / riseSeconds);
  }

  void _paintStun(Canvas canvas, Color color) {
    final opacity = _lingeringOpacity(startsAt: _impactsAt + _stunDelay, fadeSeconds: _stunFade, riseSeconds: _stunRise);
    for (final unit in _struckUnits) {
      final headTop = Offset(unit.stagePoint.dx, unit.headTopY - _stunLift);
      ActionEffectPainter.paintStunStars(canvas, headTop, seconds: _seconds, color: color, opacity: opacity);
    }
  }

  void _paintImpactFlash(Canvas canvas) {
    final flashColor = _dash?.color ?? _projectile?.color;
    ActionEffectPainter.paintImpactFlash(
      canvas,
      _target.stagePoint - Offset(_heading.dx * 20, 30),
      progress: (_seconds - _impactsAt) / _flashSeconds,
      color: flashColor == null ? _white : _colorOf(flashColor),
    );
  }
}

enum _DashStage { charging, striking, returning, done }

Color _colorOf(SpriteColor color) => Color(color.argb);

double _easeOut(double progress) {
  final clamped = progress.clamp(0.0, 1.0);
  return 1 - (1 - clamped) * (1 - clamped);
}

double _smoothStep(double progress) {
  final clamped = progress.clamp(0.0, 1.0);
  return clamped * clamped * (3 - 2 * clamped);
}
