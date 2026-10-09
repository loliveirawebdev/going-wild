import 'package:flutter/widgets.dart';

typedef TransientEffect<Effect> = ({int id, Effect effect});

mixin TransientEffects<Owner extends StatefulWidget, Effect extends Object> on State<Owner> {
  var _nextEffectId = 0;
  var _transientEffects = <TransientEffect<Effect>>[];

  List<TransientEffect<Effect>> get transientEffects => _transientEffects;

  Map<Effect, int> get transientEffectIds => {for (final transientEffect in _transientEffects) transientEffect.effect: transientEffect.id};

  void seedEffects(Iterable<Effect> effects, {bool replacesEqualEffects = false}) {
    final newEffects = [for (final effect in effects) (id: _nextEffectId++, effect: effect)];
    if (newEffects.isEmpty) return;

    final newEffectValues = {for (final newEffect in newEffects) newEffect.effect};
    final keptEffects = replacesEqualEffects
        ? _transientEffects.where((transientEffect) => !newEffectValues.contains(transientEffect.effect))
        : _transientEffects;
    _transientEffects = [...keptEffects, ...newEffects];
  }

  void spawnEffects(Iterable<Effect> effects, {bool replacesEqualEffects = false}) {
    final effectList = effects.toList();
    if (effectList.isEmpty) return;
    setState(() => seedEffects(effectList, replacesEqualEffects: replacesEqualEffects));
  }

  void finishEffect(int effectId) {
    if (!_transientEffects.any((transientEffect) => transientEffect.id == effectId)) return;
    setState(() => _transientEffects = [..._transientEffects.where((transientEffect) => transientEffect.id != effectId)]);
  }
}
