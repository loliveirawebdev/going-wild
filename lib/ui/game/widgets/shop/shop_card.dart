import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/character/stats/stats.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/domain/models/set/team_set.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_color_filters.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/design/rarity_color.dart';
import 'package:going_wild/ui/core/localization/character_name.dart';
import 'package:going_wild/ui/core/widgets/pressable.dart';
import 'package:going_wild/ui/game/widgets/shop/coin_cost.dart';
import 'package:going_wild/ui/game/widgets/shop/shop_card_art.dart';
import 'package:going_wild/ui/game/widgets/shop/shop_card_state.dart';
import 'package:going_wild/ui/game/widgets/shop/sold_stamp.dart';

const shopCardDepth = 5.0;
const shopCardBandHeight = 30.0;
const _innerRadius = BorderRadius.all(Radius.circular(14 - AppBorderWidth.thick));

const _nameStyle = TextStyle(
  fontSize: 15,
  height: 18 / 15,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w900,
);

class ShopCard extends StatelessWidget {
  const ShopCard({
    required this.sets,
    required this.stats,
    required this.state,
    required this.character,
    required this.priceInCoins,
    super.key,
    this.onPressed,
    this.disabledReason,
  });

  final Stats stats;
  final int priceInCoins;
  final Character character;
  final List<TeamSet> sets;
  final ShopCardState state;
  final String? disabledReason;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final card = _buildCard(context);

    return Pressable(
      onPressed: onPressed,
      disabledReason: disabledReason,
      semanticLabel: state == ShopCardState.sold
          ? context.t.game.shop.soldOfferLabel
          : context.t.game.shop.offerLabel(name: characterNameOf(context.t, character), price: priceInCoins),
      builder: (context, pressedAmount, child) {
        final sink = state.isRaised ? shopCardDepth * pressedAmount : shopCardDepth;

        return Padding(
          padding: EdgeInsets.only(top: sink, bottom: shopCardDepth - sink),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: AppRadius.medium,
              boxShadow: [
                if (state.isRaised) BoxShadow(color: AppColors.surface400, offset: Offset(0, shopCardDepth - sink)),
              ],
            ),
            child: child,
          ),
        );
      },
      child: switch (state) {
        ShopCardState.locked => ColorFiltered(colorFilter: AppColorFilters.lockedCard, child: card),
        _ => card,
      },
    );
  }

  Widget _buildCard(BuildContext context) {
    final isSold = state == ShopCardState.sold;
    final rarityColor = rarityColorOf(character.rarity);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface200,
        borderRadius: AppRadius.medium,
        border: Border.all(color: isSold ? AppColors.surface400 : rarityColor, width: AppBorderWidth.thick),
      ),
      child: ClipRRect(
        borderRadius: _innerRadius,
        child: Stack(
          children: [
            isSold ? ColorFiltered(colorFilter: AppColorFilters.soldCard, child: _buildContent(context)) : _buildContent(context),
            if (isSold)
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Center(child: SoldStamp()),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final isUnaffordable = state == ShopCardState.unaffordable;
    final rarityColor = rarityColorOf(character.rarity);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ShopCardArt(sets: sets, stats: stats, character: character, isFaded: isUnaffordable),
        Container(
          height: shopCardBandHeight,
          color: isUnaffordable ? AppColors.surface300 : rarityColor,
          padding: const EdgeInsets.only(left: 9, right: 8),
          child: Row(
            spacing: 3,
            children: [
              Expanded(
                child: Text(
                  characterNameOf(context.t, character),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _nameStyle.copyWith(color: isUnaffordable ? AppColors.inkMuted : AppColors.onPrimary),
                ),
              ),
              CoinCost(
                coinSize: 18,
                fontSize: 19,
                isDimmed: isUnaffordable,
                costInCoins: priceInCoins,
                color: isUnaffordable ? AppColors.danger : AppColors.onPrimary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
