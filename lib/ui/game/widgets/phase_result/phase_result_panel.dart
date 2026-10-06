import 'package:flutter/widgets.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_shadows.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/design/game_icon.dart';
import 'package:going_wild/ui/core/widgets/button.dart';
import 'package:going_wild/ui/core/widgets/game_icon_image.dart';
import 'package:going_wild/ui/game/widgets/match_top_bar/lives_counter.dart';
import 'package:going_wild/ui/game/widgets/phase_result/phase_result_stat.dart';
import 'package:going_wild/ui/game/widgets/round_banner/banner_ribbon.dart';

const _maxPanelWidth = 330.0;
const _sealDiameter = 72.0;
const _sealIconSize = 44.0;
const _sealOverlap = 16.0;
const _headOverhang = 20.0;
const _headLift = 46.0;
const _heartSize = 22.0;
const _ribbonHeightToWidth = 98 / 340;

const _phaseStyle = TextStyle(
  fontSize: 14,
  height: 19 / 14,
  color: AppColors.inkMuted,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w700,
);

const _roundsStyle = TextStyle(
  fontSize: 24,
  height: 28 / 24,
  color: AppColors.ink,
  fontFamily: AppFonts.display,
  fontWeight: FontWeight.w400,
);

const _messageStyle = TextStyle(
  fontSize: 14,
  height: 20 / 14,
  color: AppColors.ink,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w600,
);

class PhaseResultPanel extends StatelessWidget {
  final int lives;
  final int maxLives;
  final bool isVictory;
  final String phaseName;
  final int phaseNumber;
  final int roundsReached;
  final int roundCount;
  final VoidCallback onBack;
  final VoidCallback onRetry;
  const PhaseResultPanel({
    required this.lives,
    required this.onBack,
    required this.onRetry,
    required this.maxLives,
    required this.isVictory,
    required this.phaseName,
    required this.roundCount,
    required this.phaseNumber,
    required this.roundsReached,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final translations = context.t.game.phaseResult;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: _maxPanelWidth),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final headWidth = constraints.maxWidth + _headOverhang * 2;
          final headHeight = _sealDiameter - _sealOverlap + headWidth * _ribbonHeightToWidth;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(AppSpacing.space4, headHeight - _headLift, AppSpacing.space4, AppSpacing.space4),
                decoration: BoxDecoration(
                  color: AppColors.surface100,
                  borderRadius: AppRadius.large,
                  boxShadow: AppShadows.float,
                  border: Border.all(color: AppColors.surface400, width: AppBorderWidth.thick),
                ),
                child: Column(
                  spacing: AppSpacing.space3,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text.rich(
                      textAlign: TextAlign.center,
                      style: _phaseStyle,
                      TextSpan(
                        text: '${translations.phaseNumber(number: phaseNumber)} · ',
                        children: [
                          TextSpan(
                            text: phaseName,
                            style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      spacing: AppSpacing.space2,
                      children: [
                        Expanded(
                          child: PhaseResultStat(
                            label: translations.roundsLabel,
                            value: Text('$roundsReached/$roundCount', style: _roundsStyle),
                          ),
                        ),
                        Expanded(
                          child: PhaseResultStat(
                            label: translations.livesLabel,
                            value: LivesCounter(
                              lives: lives,
                              maxLives: maxLives,
                              heartSize: _heartSize,
                              semanticLabel: context.t.game.topBar.lives(lives: lives, maxLives: maxLives),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (!isVictory) Text(translations.defeatMessage, textAlign: TextAlign.center, style: _messageStyle),
                    ..._buildActions(context),
                  ],
                ),
              ),
              Positioned(top: -_headLift, left: -_headOverhang, right: -_headOverhang, child: _buildHead(context)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHead(BuildContext context) {
    final translations = context.t.game.phaseResult;

    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: _sealDiameter,
            height: _sealDiameter,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface100,
              boxShadow: AppShadows.float,
              border: Border.all(color: AppColors.surface400, width: AppBorderWidth.thick),
            ),
            child: GameIconImage(isVictory ? GameIcon.trophy : GameIcon.heart, size: _sealIconSize),
          ),
          Transform.translate(
            offset: const Offset(0, -_sealOverlap),
            child: BannerRibbon(
              tone: isVictory ? BannerRibbonTone.victory : BannerRibbonTone.defeat,
              title: isVictory ? translations.victoryTitle : translations.defeatTitle,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final translations = context.t.game.phaseResult;

    if (isVictory) {
      return [
        Button(fillsWidth: true, size: ButtonSize.large, label: translations.continueButton, onPressed: onBack),
      ];
    }

    return [
      Button(fillsWidth: true, size: ButtonSize.large, label: translations.retryButton, onPressed: onRetry),
      Button(fillsWidth: true, variant: ButtonVariant.secondary, label: translations.backButton, onPressed: onBack),
    ];
  }
}
