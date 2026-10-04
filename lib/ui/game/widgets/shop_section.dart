import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/match_progress/errors/rejected_player_action_error.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/use_cases/level/buy_experience.dart';
import 'package:going_wild/domain/use_cases/shop/buy_shop_offer.dart';
import 'package:going_wild/domain/use_cases/shop/reroll_shop.dart';
import 'package:going_wild/domain/use_cases/shop/toggle_shop_lock.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/character_name.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/experience_bought.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/shop_lock_toggled.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/shop_offer_bought.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/shop_rerolled.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/widgets/attack_range_label.dart';
import 'package:going_wild/ui/game/widgets/rejection_tooltip.dart';

class ShopSection extends StatelessWidget {
  const ShopSection({required this.matchProgress, super.key});

  final MatchProgress matchProgress;

  @override
  Widget build(BuildContext context) {
    final translations = context.t.game;
    final shop = matchProgress.shop;
    final preparationBloc = context.read<PreparationBloc>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Text(translations.shop, style: Theme.of(context).textTheme.titleMedium),
        Row(
          children: [
            for (final (offerIndex, offeredCharacter) in shop.offers.indexed)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: _ShopOfferButton(
                    matchProgress: matchProgress,
                    offeredCharacter: offeredCharacter,
                    rejection: checkBuyingShopOffer(matchProgress, offerIndex: offerIndex),
                    onPressed: () => preparationBloc.add(ShopOfferBought(offerIndex: offerIndex)),
                  ),
                ),
              ),
          ],
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _CheckedButton(
              label: translations.rerollButton,
              rejection: checkRerollingShop(matchProgress),
              onPressed: () => preparationBloc.add(const ShopRerolled()),
            ),
            _CheckedButton(
              rejection: checkTogglingShopLock(matchProgress),
              onPressed: () => preparationBloc.add(const ShopLockToggled()),
              label: shop.isLocked ? translations.unlockButton : translations.lockButton,
            ),
            _CheckedButton(
              label: translations.buyExperienceButton,
              rejection: checkBuyingExperience(matchProgress),
              onPressed: () => preparationBloc.add(const ExperienceBought()),
            ),
          ],
        ),
      ],
    );
  }
}

class _CheckedButton extends StatelessWidget {
  const _CheckedButton({required this.label, required this.onPressed, required this.rejection});

  final String label;
  final VoidCallback onPressed;
  final RejectedPlayerActionError? rejection;

  @override
  Widget build(BuildContext context) {
    return RejectionTooltip(
      rejection: rejection,
      child: OutlinedButton(onPressed: rejection == null ? onPressed : null, child: Text(label)),
    );
  }
}

class _ShopOfferButton extends StatelessWidget {
  const _ShopOfferButton({required this.onPressed, required this.rejection, required this.matchProgress, required this.offeredCharacter});

  final VoidCallback onPressed;
  final RejectedPlayerActionError? rejection;
  final Character? offeredCharacter;
  final MatchProgress matchProgress;

  @override
  Widget build(BuildContext context) {
    final translations = context.t;
    final offeredCharacter = this.offeredCharacter;
    final textTheme = Theme.of(context).textTheme;

    if (offeredCharacter == null) {
      return OutlinedButton(onPressed: null, child: Text(translations.game.emptyOffer, style: textTheme.labelSmall));
    }

    final price = matchProgress.phase.engines.economyEngine.priceOf(offeredCharacter, matchProgress: matchProgress);
    final attackRangeLabel = attackRangeLabelOf(translations, attackRangeOf(matchProgress, offeredCharacter));

    return RejectionTooltip(
      rejection: rejection,
      child: OutlinedButton(
        onPressed: rejection == null ? onPressed : null,
        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2)),
        child: Column(
          children: [
            Text(
              characterNameOf(translations, offeredCharacter),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.labelSmall,
            ),
            Text(attackRangeLabel, maxLines: 1, style: textTheme.labelSmall),
            Text(translations.game.offerPrice(price: price), style: textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}
