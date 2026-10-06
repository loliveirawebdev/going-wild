import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/round_result/round_result.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_shadows.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/design/game_icon.dart';
import 'package:going_wild/ui/core/widgets/game_icon_image.dart';
import 'package:going_wild/ui/core/widgets/pop_in.dart';
import 'package:going_wild/ui/game/widgets/round_banner/banner_ribbon.dart';
import 'package:going_wild/ui/game/widgets/round_banner/reward_pill.dart';
import 'package:going_wild/ui/game/widgets/round_banner/victory_rays.dart';
import 'package:going_wild/ui/game/widgets/round_banner/victory_sparks.dart';

const _displayDuration = Duration(milliseconds: 2400);
const _badgePopDuration = Duration(milliseconds: 500);
const _maxStackWidth = 340.0;
const _badgeDiameter = 76.0;
const _badgeIconSize = 48.0;
const _badgeOverlap = 12.0;

const _subtitleStyle = TextStyle(
  fontSize: 15,
  height: 21 / 15,
  color: AppColors.onPrimary,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w800,
  shadows: [Shadow(color: AppColors.wood700, offset: Offset(0, 2))],
);

class ResultBanner extends StatefulWidget {
  final VoidCallback onDone;
  final RoundResult roundResult;
  const ResultBanner({required this.onDone, required this.roundResult, super.key});

  @override
  State<ResultBanner> createState() => _ResultBannerState();
}

class _ResultBannerState extends State<ResultBanner> {
  Timer? _doneTimer;

  @override
  void initState() {
    super.initState();
    _doneTimer = Timer(_displayDuration, widget.onDone);
  }

  @override
  void dispose() {
    _doneTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final roundResult = widget.roundResult;
    final isVictory = roundResult.isVictory;
    final translations = context.t.game.roundBanner;
    final popDuration = MediaQuery.disableAnimationsOf(context) ? Duration.zero : _badgePopDuration;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: _maxStackWidth),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          if (isVictory) const OverflowBox(maxWidth: double.infinity, maxHeight: double.infinity, child: VictoryRays()),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PopIn(
                duration: popDuration,
                child: _ResultBadge(icon: isVictory ? GameIcon.trophy : GameIcon.heart),
              ),
              Transform.translate(
                offset: const Offset(0, -_badgeOverlap),
                child: isVictory
                    ? VictorySparks(
                        child: BannerRibbon(tone: BannerRibbonTone.victory, title: translations.victoryTitle),
                      )
                    : BannerRibbon(tone: BannerRibbonTone.defeat, title: translations.defeatTitle),
              ),
              Text(
                isVictory ? translations.victorySubtitle(round: roundResult.roundNumber) : translations.defeatSubtitle,
                textAlign: TextAlign.center,
                style: _subtitleStyle,
              ),
              const SizedBox(height: AppSpacing.space3),
              Wrap(
                spacing: AppSpacing.space2,
                runSpacing: AppSpacing.space2,
                alignment: WrapAlignment.center,
                children: _buildRewards(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRewards(BuildContext context) {
    final translations = context.t.game.roundBanner;
    final roundResult = widget.roundResult;
    final coinsPill = roundResult.coinsGained > 0
        ? RewardPill(
            icon: GameIcon.gold,
            value: '+${roundResult.coinsGained}',
            label: translations.coins(count: roundResult.coinsGained),
          )
        : null;

    if (!roundResult.isVictory) {
      return [
        if (roundResult.livesLost > 0)
          RewardPill(
            isNegative: true,
            icon: GameIcon.heart,
            value: '−${roundResult.livesLost}',
            label: translations.lives(count: roundResult.livesLost),
          ),
        ?coinsPill,
      ];
    }

    return [
      ?coinsPill,
      if (roundResult.experienceGained > 0)
        RewardPill(icon: GameIcon.experience, value: '+${roundResult.experienceGained}', label: translations.experience),
    ];
  }
}

class _ResultBadge extends StatelessWidget {
  final GameIcon icon;
  const _ResultBadge({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _badgeDiameter,
      height: _badgeDiameter,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surface100,
        boxShadow: AppShadows.float,
        border: Border.all(color: AppColors.surface400, width: AppBorderWidth.thick),
      ),
      child: GameIconImage(icon, size: _badgeIconSize),
    );
  }
}
