import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/ui/core/widgets/transient_effects.dart';

class _EffectsHost extends StatefulWidget {
  const _EffectsHost();

  @override
  State<_EffectsHost> createState() => _EffectsHostState();
}

class _EffectsHostState extends State<_EffectsHost> with TransientEffects<_EffectsHost, String> {
  @override
  Widget build(BuildContext context) => const SizedBox();
}

void main() {
  testWidgets('effects get their own id, stay until finished and can replace an equal effect still running', (tester) async {
    await tester.pumpWidget(const _EffectsHost());
    final host = tester.state<_EffectsHostState>(find.byType(_EffectsHost));

    host.spawnEffects(['poof', 'pebble']);
    final firstIds = host.transientEffectIds;
    expect(firstIds.keys, ['poof', 'pebble']);
    expect(firstIds['poof'], isNot(firstIds['pebble']));

    host.spawnEffects(['poof'], replacesEqualEffects: true);
    expect(host.transientEffects.where((transientEffect) => transientEffect.effect == 'poof'), hasLength(1));
    expect(host.transientEffectIds['poof'], isNot(firstIds['poof']));

    host.finishEffect(firstIds['poof']!);
    expect(host.transientEffects, hasLength(2));

    host.finishEffect(firstIds['pebble']!);
    expect(host.transientEffectIds.keys, ['poof']);
  });
}
