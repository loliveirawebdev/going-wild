import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/game/widgets/shop/coin_cost.dart';

class CoinCostPill extends StatelessWidget {
  final bool isDimmed;
  final int costInCoins;
  const CoinCostPill({required this.costInCoins, required this.isDimmed, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(2, 2, 7, 2),
      decoration: BoxDecoration(
        borderRadius: AppRadius.pill,
        color: AppColors.surface100.withValues(alpha: 0.7),
        border: Border.all(color: AppColors.surface400, width: AppBorderWidth.thin),
      ),

      child: CoinCost(
        coinSize: 16,
        fontSize: 15,
        isDimmed: isDimmed,
        costInCoins: costInCoins,
        color: isDimmed ? AppColors.onDisabled : AppColors.ink,
      ),
    );
  }
}
