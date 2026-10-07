import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/rejection_message.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/experience_bought.dart';
import 'package:going_wild/ui/game/view_models/preparation/player_options.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/widgets/match_shelves/buy_experience_button.dart';
import 'package:going_wild/ui/game/widgets/match_shelves/level_meter.dart';
import 'package:going_wild/ui/game/widgets/match_shelves/shelf_pill.dart';

class ExperiencePill extends StatelessWidget {
  const ExperiencePill({required this.matchProgress, super.key});

  final MatchProgress matchProgress;

  @override
  Widget build(BuildContext context) {
    final translations = context.t.game.infoShelf;
    final engines = matchProgress.phase.engines;
    final level = matchProgress.playerLevelProgress.level;
    final experience = matchProgress.playerLevelProgress.experience;
    final isMaxLevel = engines.levelEngine.isMaxLevel(level);

    return ShelfPill(
      padding: const EdgeInsets.only(left: 3, right: 4),
      child: Row(
        spacing: 6,
        children: [
          Expanded(
            child: isMaxLevel
                ? LevelMeter(
                    level: level.number,
                    experience: experience,
                    experienceToNextLevel: null,
                    label: translations.maxLevel,
                    semanticLabel: translations.maxLevelLabel(level: level.number),
                  )
                : LevelMeter(
                    level: level.number,
                    experience: experience,
                    experienceToNextLevel: level.experienceToNextLevel,
                    label: translations.experience(experience: experience, experienceToNextLevel: level.experienceToNextLevel),
                    semanticLabel: translations.levelLabel(
                      level: level.number,
                      experience: experience,
                      experienceToNextLevel: level.experienceToNextLevel,
                    ),
                  ),
          ),
          if (!isMaxLevel) _buildBuyExperienceButton(context),
        ],
      ),
    );
  }

  Widget _buildBuyExperienceButton(BuildContext context) {
    final translations = context.t.game.infoShelf;
    final (:rejection, :costInCoins) = PlayerOptions(matchProgress).experiencePurchase;

    return BuyExperienceButton(
      costInCoins: costInCoins,
      label: translations.buyExperienceButton,
      semanticLabel: translations.buyExperienceLabel(cost: costInCoins),
      disabledReason: rejection == null ? null : rejectionMessageOf(context.t, rejection),
      onPressed: rejection == null ? () => context.read<PreparationBloc>().add(const ExperienceBought()) : null,
    );
  }
}
