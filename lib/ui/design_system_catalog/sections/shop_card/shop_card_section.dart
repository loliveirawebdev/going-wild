import 'package:flutter/widgets.dart';
import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/content/phase/backyard/backyard.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_block_title.dart';
import 'package:going_wild/ui/design_system_catalog/catalog_tap_log.dart';
import 'package:going_wild/ui/game/widgets/shop/shop_card.dart';
import 'package:going_wild/ui/game/widgets/shop/shop_card_state.dart';
import 'package:going_wild/ui/game/widgets/shop/sold_shop_card.dart';

const _cardWidth = 170.0;

class ShopCardSection extends StatelessWidget {
  const ShopCardSection({super.key});

  @override
  Widget build(BuildContext context) {
    final engines = backyard.engines;

    return CatalogTapLog(
      builder: (context, tapOf) {
        Widget cardOf(Character character, ShopCardState state, {String? disabledReason}) => SizedBox(
          width: _cardWidth,
          child: ShopCard(
            state: state,
            character: character,
            disabledReason: disabledReason,
            sets: engines.setEngine.setsOf(character),
            priceInCoins: character.rarity.index + 1,
            stats: engines.characterEngine.statsAtStars(character, stars: 1),
            onPressed: state == ShopCardState.normal ? tapOf(character.id.value) : null,
          ),
        );

        return ListView(
          padding: const EdgeInsets.all(AppSpacing.space4),
          children: [
            const CatalogBlockTitle('Estados'),
            Wrap(
              spacing: AppSpacing.space3,
              runSpacing: AppSpacing.space3,
              children: [
                cardOf(cat, ShopCardState.normal),
                cardOf(queenBee, ShopCardState.unaffordable, disabledReason: 'Moedas insuficientes'),
                cardOf(bull, ShopCardState.locked, disabledReason: 'A luta está acontecendo'),
                const SizedBox(width: _cardWidth, child: SoldShopCard()),
              ],
            ),
            const CatalogBlockTitle('Todos do time'),
            Wrap(
              spacing: AppSpacing.space3,
              runSpacing: AppSpacing.space3,
              children: [for (final character in allTeamCharacters) cardOf(character, ShopCardState.normal)],
            ),
          ],
        );
      },
    );
  }
}
