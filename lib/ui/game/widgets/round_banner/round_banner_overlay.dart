import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/game/view_models/round_banner/round_banner.dart';
import 'package:going_wild/ui/game/view_models/round_banner/round_banner_view_model.dart';
import 'package:going_wild/ui/game/widgets/round_banner/countdown_banner.dart';
import 'package:going_wild/ui/game/widgets/round_banner/result_banner.dart';

const _fadeDuration = Duration(milliseconds: 200);
const _countdownVeilOpacity = 0.28;
const _victoryVeilOpacity = 0.42;
const _defeatVeilOpacity = 0.55;

class RoundBannerOverlay extends StatelessWidget {
  const RoundBannerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoundBannerViewModel, RoundBanner?>(
      builder: (context, roundBanner) => AnimatedSwitcher(
        duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : _fadeDuration,
        child: switch (roundBanner) {
          null => const SizedBox.shrink(),
          final CountdownRoundBanner countdownBanner => _Veil(
            key: ObjectKey(countdownBanner),
            opacity: _countdownVeilOpacity,
            semanticLabel: context.t.game.roundBanner.countdownLabel,
            child: CountdownBanner(onDone: context.read<RoundBannerViewModel>().dismiss),
          ),
          final ResultRoundBanner resultBanner => _Veil(
            key: ObjectKey(resultBanner),
            onPressed: context.read<RoundBannerViewModel>().dismiss,
            opacity: resultBanner.isVictory ? _victoryVeilOpacity : _defeatVeilOpacity,
            semanticLabel: resultBanner.isVictory ? context.t.game.roundBanner.victoryTitle : context.t.game.roundBanner.defeatTitle,
            child: ResultBanner(resultBanner: resultBanner, onDone: context.read<RoundBannerViewModel>().dismiss),
          ),
        },
      ),
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
