import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_shadows.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/widgets/pop_in.dart';
import 'package:going_wild/ui/game/widgets/round_banner/banner_ribbon.dart';

const _countdownStart = 3;
const _numberInterval = Duration(milliseconds: 1000);
const _goDuration = Duration(milliseconds: 800);
const _numberPopDuration = Duration(milliseconds: 450);
const _numberDiameter = 128.0;
const _numberBorderWidth = 4.0;
const _numberDepth = 6.0;
const _maxRibbonWidth = 340.0;

const _labelStyle = TextStyle(
  fontSize: 18,
  height: 24 / 18,
  color: AppColors.onPrimary,
  fontFamily: AppFonts.display,
  fontWeight: FontWeight.w400,
);

const _numberStyle = TextStyle(
  height: 1,
  fontSize: 84,
  color: AppColors.ink,
  fontFamily: AppFonts.display,
  fontWeight: FontWeight.w400,
);

class CountdownBanner extends StatefulWidget {
  final VoidCallback onDone;
  const CountdownBanner({required this.onDone, super.key});

  @override
  State<CountdownBanner> createState() => _CountdownBannerState();
}

class _CountdownBannerState extends State<CountdownBanner> {
  var _number = _countdownStart;
  Timer? _numberTimer;
  Timer? _goTimer;

  @override
  void initState() {
    super.initState();
    _numberTimer = Timer.periodic(_numberInterval, (timer) {
      setState(() => _number--);
      if (_number > 0) return;
      timer.cancel();
      _goTimer = Timer(_goDuration, widget.onDone);
    });
  }

  @override
  void dispose() {
    _numberTimer?.cancel();
    _goTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translations = context.t.game.roundBanner;
    final popDuration = MediaQuery.disableAnimationsOf(context) ? Duration.zero : _numberPopDuration;

    if (_number <= 0) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxRibbonWidth),
        child: BannerRibbon(tone: BannerRibbonTone.go, title: translations.goTitle),
      );
    }

    return Column(
      spacing: AppSpacing.space3,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppShadows.pressOffset),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: AppSpacing.space4),
            decoration: BoxDecoration(
              color: AppColors.wood500,
              borderRadius: AppRadius.pill,
              border: Border.all(color: AppColors.wood700, width: AppBorderWidth.thick),
              boxShadow: const [BoxShadow(color: AppColors.wood700, offset: Offset(0, AppShadows.pressOffset))],
            ),
            child: Text(translations.countdownLabel, style: _labelStyle),
          ),
        ),
        PopIn(
          key: ValueKey(_number),
          duration: popDuration,
          child: Container(
            width: _numberDiameter,
            height: _numberDiameter,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface100,
              border: Border.all(color: AppColors.surface400, width: _numberBorderWidth),
              boxShadow: [
                const BoxShadow(color: AppColors.surface400, offset: Offset(0, _numberDepth)),
                ...AppShadows.float,
              ],
            ),
            child: Text('$_number', style: _numberStyle),
          ),
        ),
      ],
    );
  }
}
