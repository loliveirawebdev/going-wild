import 'package:flutter/widgets.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_shadows.dart';
import 'package:going_wild/ui/core/design/game_icon.dart';
import 'package:going_wild/ui/core/widgets/game_icon_image.dart';
import 'package:going_wild/ui/core/widgets/pressable_surface.dart';
import 'package:going_wild/ui/game/widgets/shop/shop_sheet.dart';

const _iconSize = 30.0;

class BenchShopTile extends StatelessWidget {
  final Size size;
  final double radius;
  const BenchShopTile({required this.size, required this.radius, super.key});

  @override
  Widget build(BuildContext context) {
    return PressableSurface(
      width: size.width,
      edgeColor: AppColors.sun600,
      fillColor: AppColors.sun400,
      onPressed: () => presentShopSheet(context),
      height: size.height - AppShadows.pressOffset,
      semanticLabel: context.t.game.bench.shopButton,
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      child: const Center(child: GameIconImage(GameIcon.shop, size: _iconSize)),
    );
  }
}
