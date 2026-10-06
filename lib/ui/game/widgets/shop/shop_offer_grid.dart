import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/match_progress/match_progress.dart';
import 'package:going_wild/domain/models/player/errors/not_enough_coins_error.dart';
import 'package:going_wild/domain/use_cases/shop/buy_shop_offer.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/localization/rejection_message.dart';
import 'package:going_wild/ui/game/view_models/preparation/events/shop_offer_bought.dart';
import 'package:going_wild/ui/game/view_models/preparation/preparation_bloc.dart';
import 'package:going_wild/ui/game/widgets/shop/shop_card.dart';
import 'package:going_wild/ui/game/widgets/shop/shop_card_state.dart';
import 'package:going_wild/ui/game/widgets/shop/sold_shop_card.dart';

const _columnCount = 2;
const _rowSpacing = 10.0;
const _columnSpacing = 12.0;

class ShopOfferGrid extends StatelessWidget {
  final MatchProgress matchProgress;
  const ShopOfferGrid({required this.matchProgress, super.key});

  @override
  Widget build(BuildContext context) {
    final offers = matchProgress.shop.offers;

    return Column(
      spacing: _rowSpacing,
      children: [
        for (var rowStart = 0; rowStart < offers.length; rowStart += _columnCount)
          Row(
            spacing: _columnSpacing,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var offerIndex = rowStart; offerIndex < rowStart + _columnCount; offerIndex++)
                Expanded(child: offerIndex < offers.length ? _buildOffer(context, offerIndex) : const SizedBox.shrink()),
            ],
          ),
      ],
    );
  }

  Widget _buildOffer(BuildContext context, int offerIndex) {
    final shop = matchProgress.shop;
    final character = shop.offers[offerIndex] ?? shop.soldOfferAt(offerIndex);
    if (character == null) return const SoldShopCard();

    final engines = matchProgress.phase.engines;
    final rejection = checkBuyingShopOffer(matchProgress, offerIndex: offerIndex);

    return ShopCard(
      character: character,
      stats: engines.characterEngine.statsAtStars(character, stars: 1),
      sets: engines.setEngine.setsOf(character),
      state: _stateOf(isSold: shop.offers[offerIndex] == null, isRejectedForCoins: rejection is NotEnoughCoinsError),
      priceInCoins: engines.economyEngine.priceOf(character, matchProgress: matchProgress),
      disabledReason: rejection == null ? null : rejectionMessageOf(context.t, rejection),
      onPressed: rejection == null ? () => context.read<PreparationBloc>().add(ShopOfferBought(offerIndex: offerIndex)) : null,
    );
  }

  ShopCardState _stateOf({required bool isSold, required bool isRejectedForCoins}) {
    if (isSold) return ShopCardState.sold;
    if (matchProgress.checkPreparingActions() != null) return ShopCardState.locked;
    if (isRejectedForCoins) return ShopCardState.unaffordable;
    return ShopCardState.normal;
  }
}
