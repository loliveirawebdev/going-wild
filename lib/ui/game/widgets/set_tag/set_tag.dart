import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/set/team_set.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/localization/set_name.dart';
import 'package:going_wild/ui/core/widgets/pill.dart';
import 'package:going_wild/ui/core/widgets/set_icon_image.dart';

enum SetTagSize {
  regular(iconSize: 15, spacing: 4, fillOpacity: 0.85, lineHeight: 16, padding: EdgeInsets.fromLTRB(3, 1, 8, 1)),
  compact(iconSize: 14, spacing: 3, fillOpacity: 0.78, lineHeight: 15, padding: EdgeInsets.fromLTRB(2, 0, 6, 0));

  final double iconSize;
  final double spacing;
  final double lineHeight;
  final double fillOpacity;
  final EdgeInsets padding;
  const SetTagSize({
    required this.iconSize,
    required this.spacing,
    required this.padding,
    required this.lineHeight,
    required this.fillOpacity,
  });
}

class SetTag extends StatelessWidget {
  const SetTag({required this.set, required this.size, super.key});

  final TeamSet set;
  final SetTagSize size;

  @override
  Widget build(BuildContext context) {
    return Pill(
      spacing: size.spacing,
      padding: size.padding,
      color: AppColors.surface100.withValues(alpha: size.fillOpacity),
      leading: SetIconImage(set.id, size: size.iconSize),
      child: Text(
        setNameOf(context.t, set),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(color: AppColors.ink, height: size.lineHeight / AppTextStyles.caption.fontSize!),
      ),
    );
  }
}
