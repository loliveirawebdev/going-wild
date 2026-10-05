import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_color_filters.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/design/game_icon.dart';
import 'package:going_wild/ui/core/widgets/game_icon_image.dart';

const _costStyle = TextStyle(fontFamily: AppFonts.display, fontWeight: FontWeight.w400);

class CoinCost extends StatelessWidget {
  final Color? color;
  final bool isDimmed;
  final double coinSize;
  final double fontSize;
  final int costInCoins;
  const CoinCost({required this.costInCoins, super.key, this.coinSize = 14, this.fontSize = 14, this.color, this.isDimmed = false});

  @override
  Widget build(BuildContext context) {
    final coin = GameIconImage(GameIcon.gold, size: coinSize);

    return Row(
      spacing: 2,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isDimmed) ColorFiltered(colorFilter: AppColorFilters.disabledIcon, child: coin) else coin,
        Text(
          '$costInCoins',
          style: _costStyle.copyWith(fontSize: fontSize, height: 1, color: color),
        ),
      ],
    );
  }
}
