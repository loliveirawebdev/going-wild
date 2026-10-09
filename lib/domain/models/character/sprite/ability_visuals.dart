import 'package:going_wild/domain/models/character/sprite/action_effect.dart';
import 'package:going_wild/domain/models/character/sprite/hex_effect.dart';

const _defaultEffectDuration = Duration(seconds: 3);

class AbilityVisuals {
  const AbilityVisuals({this.hexEffect, this.actionEffects = const []});

  final HexEffect? hexEffect;
  final List<ActionEffect> actionEffects;

  Duration get effectDuration => hexEffect?.duration ?? _defaultEffectDuration;
}
