import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/game/widgets/set_chips/celebration/celebration_ring.dart';
import 'package:going_wild/ui/game/widgets/set_chips/celebration/eased_ping_pong.dart';
import 'package:going_wild/ui/game/widgets/set_chips/celebration/twinkling_spark.dart';

const _bobHeight = 3.0;
const _sparkCycleDuration = Duration(milliseconds: 1600);
const _celebrationCycleDuration = Duration(milliseconds: 2400);

const _sparks = [
  SparkPlacement(top: -15, left: -14, size: 20, cycleOffset: 0),
  SparkPlacement(top: -16, right: -8, size: 15, cycleOffset: 0.5 / 1.6),
  SparkPlacement(bottom: 2, left: -17, size: 13, cycleOffset: 1 / 1.6),
];

class SetChipCelebration extends StatefulWidget {
  const SetChipCelebration({required this.badgeBuilder, super.key});

  final Widget Function(BuildContext context, Animation<double>? shineCycle) badgeBuilder;

  @override
  State<SetChipCelebration> createState() => _SetChipCelebrationState();
}

class _SetChipCelebrationState extends State<SetChipCelebration> with TickerProviderStateMixin {
  late final _sparkCycle = AnimationController(vsync: this, duration: _sparkCycleDuration);
  late final _celebrationCycle = AnimationController(vsync: this, duration: _celebrationCycleDuration);

  bool get _isMotionReduced => MediaQuery.disableAnimationsOf(context);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isMotionReduced) {
      _sparkCycle.stop();
      _celebrationCycle.stop();
      return;
    }

    _sparkCycle.repeat();
    _celebrationCycle.repeat();
  }

  @override
  void dispose() {
    _sparkCycle.dispose();
    _celebrationCycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMotionReduced = _isMotionReduced;

    return AnimatedBuilder(
      animation: _celebrationCycle,
      child: widget.badgeBuilder(context, isMotionReduced ? null : _celebrationCycle),
      builder: (context, badge) {
        final pulse = isMotionReduced ? 0.0 : easedPingPongOf(_celebrationCycle.value);

        return Transform.translate(
          offset: Offset(0, -_bobHeight * pulse),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CelebrationRing(pulse: pulse),
              badge!,
              for (final spark in _sparks)
                Positioned(
                  top: spark.top,
                  left: spark.left,
                  right: spark.right,
                  bottom: spark.bottom,
                  child: TwinklingSpark(placement: spark, sparkCycle: isMotionReduced ? null : _sparkCycle),
                ),
            ],
          ),
        );
      },
    );
  }
}
