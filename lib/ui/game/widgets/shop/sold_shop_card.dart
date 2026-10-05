import 'package:flutter/widgets.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/game/widgets/shop/shop_card.dart';
import 'package:going_wild/ui/game/widgets/shop/sold_stamp.dart';

class SoldShopCard extends StatelessWidget {
  const SoldShopCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: context.t.game.shop.soldOfferLabel,
      child: ExcludeSemantics(
        child: Padding(
          padding: const EdgeInsets.only(top: shopCardDepth),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface300,
              borderRadius: AppRadius.medium,
              border: Border.all(color: AppColors.surface400, width: AppBorderWidth.thick),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Center(child: SoldStamp()),
                ),
                SizedBox(height: shopCardBandHeight),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
