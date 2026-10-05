import 'package:flutter/widgets.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_color_filters.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_shadows.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/design/game_icon.dart';
import 'package:going_wild/ui/core/widgets/game_icon_image.dart';
import 'package:going_wild/ui/core/widgets/pressable_surface.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_sale.dart';

const _coinSize = 14.0;

const _labelStyle = TextStyle(
  fontSize: 20,
  height: 24 / 20,
  fontFamily: AppFonts.display,
  fontWeight: FontWeight.w400,
);

const _valueStyle = TextStyle(
  fontSize: 14,
  height: 16 / 14,
  fontFamily: AppFonts.display,
  fontWeight: FontWeight.w400,
);

class UnitSellButton extends StatelessWidget {
  const UnitSellButton({required this.sale, super.key});

  final UnitSale sale;

  @override
  Widget build(BuildContext context) {
    final translations = context.t.game.unitSheet;
    final onSell = sale.onSell;
    final isEnabled = onSell != null;
    final foreground = isEnabled ? AppColors.onPrimary : AppColors.onDisabled;
    const coin = GameIconImage(GameIcon.gold, size: _coinSize);

    return PressableSurface(
      borderRadius: AppRadius.medium,
      disabledReason: sale.disabledReason,
      padding: const EdgeInsets.symmetric(vertical: 10),
      fillColor: isEnabled ? AppColors.barn600 : AppColors.disabled,
      semanticLabel: translations.sellLabel(value: sale.valueInCoins),
      edgeColor: isEnabled ? AppShadows.pressBarn.first.color : AppColors.disabledShadow,
      onPressed: onSell == null
          ? null
          : () {
              onSell();
              Navigator.of(context).pop();
            },
      child: Row(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(translations.sellButton, style: _labelStyle.copyWith(color: foreground)),
          Container(
            padding: const EdgeInsets.fromLTRB(7, 2, 5, 2),
            decoration: BoxDecoration(color: AppColors.surface100.withValues(alpha: 0.25), borderRadius: AppRadius.pill),
            child: Row(
              spacing: 3,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('+${sale.valueInCoins}', style: _valueStyle.copyWith(color: foreground)),
                if (isEnabled) coin else ColorFiltered(colorFilter: AppColorFilters.disabledIcon, child: coin),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
