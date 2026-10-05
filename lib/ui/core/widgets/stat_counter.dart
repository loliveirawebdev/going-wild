import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/design/game_icon.dart';
import 'package:going_wild/ui/core/widgets/game_icon_image.dart';

const _iconSize = 24.0;
const _counterHeight = 40.0;

const _valueStyle = TextStyle(
  fontSize: 19,
  height: 24 / 19,
  color: AppColors.ink,
  fontWeight: FontWeight.w400,
  fontFamily: AppFonts.display,
);

class StatCounter extends StatelessWidget {
  final int value;
  final GameIcon icon;
  final String semanticLabel;
  const StatCounter({required this.icon, required this.value, required this.semanticLabel, super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: Container(
          height: _counterHeight,
          padding: const EdgeInsets.only(left: 4, right: 11),
          decoration: BoxDecoration(
            color: AppColors.surface100,
            borderRadius: AppRadius.pill,
            border: Border.all(color: AppColors.surface400, width: AppBorderWidth.thick),
          ),
          child: Row(
            spacing: 4,
            mainAxisSize: MainAxisSize.min,
            children: [
              GameIconImage(icon, size: _iconSize),
              Text('$value', style: _valueStyle),
            ],
          ),
        ),
      ),
    );
  }
}
