import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stats.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/game_icon.dart';
import 'package:going_wild/ui/core/widgets/game_icon_image.dart';
import 'package:going_wild/ui/game/widgets/unit_sheet/unit_badge.dart';

const _iconSize = 20.0;

class RangeBadge extends StatelessWidget {
  const RangeBadge({required this.stats, super.key});

  final Stats stats;

  @override
  Widget build(BuildContext context) {
    final translations = context.t.game.unitSheet;
    final isMelee = stats.isMelee;

    return UnitBadge(
      label: isMelee ? translations.melee : translations.ranged(range: stats[Stat.range].round()),
      icon: GameIconImage(isMelee ? GameIcon.melee : GameIcon.ranged, size: _iconSize),
    );
  }
}
