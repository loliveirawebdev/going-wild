import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';

const _riseDuration = Duration(milliseconds: 700);
const _riseHeight = 18.0;
const _fadeStart = 0.45;

const _numberStyle = TextStyle(
  fontSize: 10,
  height: 1,
  color: AppColors.barn600,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w700,
);

class FloatingDamageNumber extends StatefulWidget {
  final int amount;
  final VoidCallback onDone;
  const FloatingDamageNumber({required this.amount, required this.onDone, super.key});

  @override
  State<FloatingDamageNumber> createState() => _FloatingDamageNumberState();
}

class _FloatingDamageNumberState extends State<FloatingDamageNumber> with SingleTickerProviderStateMixin {
  late final _riseController = AnimationController(vsync: this, duration: _riseDuration);
  late final _rise = CurvedAnimation(parent: _riseController, curve: Curves.easeOutCubic);

  @override
  void initState() {
    super.initState();
    _riseController.forward().whenComplete(() {
      if (mounted) widget.onDone();
    });
  }

  @override
  void dispose() {
    _rise.dispose();
    _riseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final number = Text('${widget.amount}', style: _numberStyle);

    return AnimatedBuilder(
      animation: _riseController,
      child: number,
      builder: (context, child) {
        final fade = ((_riseController.value - _fadeStart) / (1 - _fadeStart)).clamp(0.0, 1.0);

        return Transform.translate(
          offset: Offset(0, -_riseHeight * _rise.value),
          child: Opacity(opacity: 1 - fade, child: child),
        );
      },
    );
  }
}
