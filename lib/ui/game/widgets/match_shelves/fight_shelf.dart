import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/match_progress/round_stage.dart';
import 'package:going_wild/domain/use_cases/round/start_fight.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/localization/rejection_message.dart';
import 'package:going_wild/ui/core/widgets/button.dart';
import 'package:going_wild/ui/core/widgets/speed_selector.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/combat_playback_bloc.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/combat_playback_speed.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/events/combat_playback_speed_changed.dart';
import 'package:going_wild/ui/game/view_models/combat_playback/states/combat_playback_state.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/view_models/preparation/states/preparation_state.dart';
import 'package:going_wild/ui/game/view_models/round_banner/round_banner_view_model.dart';
import 'package:going_wild/ui/game/widgets/match_shelves/match_shelf.dart';

const _speedLabelStyle = TextStyle(
  fontSize: 12,
  height: 16 / 12,
  letterSpacing: 0.6,
  color: AppColors.inkMuted,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w800,
);

class FightShelf extends StatelessWidget {
  const FightShelf({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreparationBloc, PreparationState>(
      builder: (context, state) {
        if (state is! ReadyPreparationState) return const SizedBox.shrink();
        final matchProgress = state.matchProgress;

        if (matchProgress.roundStage == RoundStage.fighting) return const _SpeedShelf();
        return _FightButton(matchProgress: matchProgress);
      },
    );
  }
}

class _FightButton extends StatelessWidget {
  final MatchProgress matchProgress;
  const _FightButton({required this.matchProgress});

  @override
  Widget build(BuildContext context) {
    final rejection = checkStartingFight(matchProgress);

    return Button(
      fillsWidth: true,
      size: ButtonSize.extraLarge,
      variant: ButtonVariant.primary,
      label: context.t.game.fightShelf.fightButton,
      disabledReason: rejection == null ? null : rejectionMessageOf(context.t, rejection),
      onPressed: rejection == null ? context.read<RoundBannerViewModel>().startCountdown : null,
    );
  }
}

class _SpeedShelf extends StatelessWidget {
  const _SpeedShelf();

  @override
  Widget build(BuildContext context) {
    return MatchShelf(
      child: Row(
        spacing: AppSpacing.space3,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(context.t.game.fightShelf.speedLabel.toUpperCase(), style: _speedLabelStyle),
          BlocBuilder<CombatPlaybackBloc, CombatPlaybackState>(
            buildWhen: (previous, current) => previous.speed != current.speed,
            builder: (context, state) => SpeedSelector(
              multiplier: state.speed.multiplier,
              onChanged: (multiplier) => context.read<CombatPlaybackBloc>().add(
                CombatPlaybackSpeedChanged(speed: CombatPlaybackSpeed.withMultiplier(multiplier)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
