import 'package:flutter/widgets.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';

const _stampTilt = -0.24;

const _stampStyle = TextStyle(
  fontSize: 15,
  letterSpacing: 0.5,
  color: AppColors.danger,
  fontFamily: AppFonts.display,
  fontWeight: FontWeight.w400,
);

class SoldStamp extends StatelessWidget {
  const SoldStamp({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: _stampTilt,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surface100,
          borderRadius: AppRadius.small,
          border: Border.all(color: AppColors.danger, width: AppBorderWidth.thick),
        ),
        child: Text(context.t.game.shop.soldStamp.toUpperCase(), style: _stampStyle),
      ),
    );
  }
}
