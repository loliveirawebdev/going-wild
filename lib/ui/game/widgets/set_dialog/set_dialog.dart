import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/set/set_presence.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/localization/set_name.dart';
import 'package:going_wild/ui/core/widgets/dialog.dart';
import 'package:going_wild/ui/game/widgets/set_dialog/set_dialog_intro.dart';
import 'package:going_wild/ui/game/widgets/set_dialog/set_dialog_section_title.dart';
import 'package:going_wild/ui/game/widgets/set_dialog/set_member_grid.dart';
import 'package:going_wild/ui/game/widgets/set_dialog/set_tier_list.dart';

Future<void> presentSetDialog(BuildContext context, {required SetPresence setPresence}) {
  return presentDialog<void>(
    context,
    dialog: SetDialog(setPresence: setPresence),
    barrierLabel: context.t.game.setDialog.closeButton,
  );
}

class SetDialog extends StatelessWidget {
  const SetDialog({required this.setPresence, super.key});

  final SetPresence setPresence;

  @override
  Widget build(BuildContext context) {
    final translations = context.t.game.setDialog;

    return Dialog(
      closeLabel: translations.closeButton,
      title: setNameOf(context.t, setPresence.set),
      body: Column(
        spacing: AppSpacing.space2,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SetDialogIntro(setPresence: setPresence),
          SetDialogSectionTitle(title: translations.levelsTitle),
          SetTierList(setPresence: setPresence),
          SetDialogSectionTitle(title: translations.membersTitle),
          SetMemberGrid(setPresence: setPresence),
        ],
      ),
    );
  }
}
