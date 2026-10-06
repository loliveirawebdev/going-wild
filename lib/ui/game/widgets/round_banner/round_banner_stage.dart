import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/round_result/round_result.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/game/widgets/round_banner/countdown_banner.dart';
import 'package:going_wild/ui/game/widgets/round_banner/result_banner.dart';

const _fadeDuration = Duration(milliseconds: 200);
const _countdownVeilOpacity = 0.28;
const _victoryVeilOpacity = 0.42;
const _defeatVeilOpacity = 0.55;

class RoundBannerStage extends StatelessWidget {
  const RoundBannerStage({
    required this.isCountingDown,
    required this.onCountdownFinished,
    required this.onRoundResultDismissed,
    super.key,
    this.roundResult,
  });

  final bool isCountingDown;
  final RoundResult? roundResult;
  final VoidCallback onCountdownFinished;
  final VoidCallback onRoundResultDismissed;

  @override
  Widget build(BuildContext context) {
    final translations = context.t.game.roundBanner;
    final roundResult = this.roundResult;

    return AnimatedSwitcher(
      duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : _fadeDuration,
      child: switch ((isCountingDown, roundResult)) {
        (true, _) => _Veil(
          key: const ValueKey('countdown'),
          opacity: _countdownVeilOpacity,
          semanticLabel: translations.countdownLabel,
          child: CountdownBanner(onDone: onCountdownFinished),
        ),
        (false, final roundResult?) => _Veil(
          key: ObjectKey(roundResult),
          onPressed: onRoundResultDismissed,
          opacity: roundResult.isVictory ? _victoryVeilOpacity : _defeatVeilOpacity,
          semanticLabel: roundResult.isVictory ? translations.victoryTitle : translations.defeatTitle,
          child: ResultBanner(roundResult: roundResult, onDone: onRoundResultDismissed),
        ),
        (false, null) => const SizedBox.shrink(),
      },
    );
  }
}

class _Veil extends StatelessWidget {
  final Widget child;
  final double opacity;
  final String semanticLabel;
  final VoidCallback? onPressed;
  const _Veil({required this.child, required this.opacity, required this.semanticLabel, super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onPressed,
        behavior: HitTestBehavior.opaque,
        child: ColoredBox(
          color: AppColors.wood700.withValues(alpha: opacity),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.space4),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
