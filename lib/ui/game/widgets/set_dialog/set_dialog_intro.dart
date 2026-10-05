import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/set/set_presence.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/localization/set_description.dart';
import 'package:going_wild/ui/game/widgets/set_chips/set_chip.dart';
import 'package:going_wild/ui/game/widgets/set_chips/set_chip_semantic_label.dart';
import 'package:going_wild/ui/game/widgets/set_dialog/set_presence_status.dart';

const _chipPadding = EdgeInsets.fromLTRB(4, 6, 9, 9);

const _descriptionStyle = TextStyle(
  fontSize: 14,
  height: 20 / 14,
  color: AppColors.ink,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w600,
);

class SetDialogIntro extends StatelessWidget {
  const SetDialogIntro({required this.setPresence, super.key});

  final SetPresence setPresence;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.space3,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: _chipPadding,
          child: SetChip(setPresence: setPresence, semanticLabel: setChipSemanticLabelOf(context, setPresence)),
        ),
        Expanded(
          child: Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SetPresenceStatus(setPresence: setPresence),
              Text(setDescriptionOf(context.t, setPresence.set), style: _descriptionStyle),
            ],
          ),
        ),
      ],
    );
  }
}
