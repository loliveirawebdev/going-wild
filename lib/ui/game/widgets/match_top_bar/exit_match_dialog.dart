import 'package:flutter/widgets.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/widgets/button.dart';
import 'package:going_wild/ui/core/widgets/dialog.dart';

Future<void> presentExitMatchDialog(BuildContext context, {required VoidCallback onExit}) {
  return presentDialog<void>(
    context,
    dialog: ExitMatchDialog(onExit: onExit),
    barrierLabel: context.t.game.exitDialog.closeButton,
  );
}

class ExitMatchDialog extends StatelessWidget {
  const ExitMatchDialog({required this.onExit, super.key});

  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    final translations = context.t.game.exitDialog;

    return Dialog(
      body: translations.body,
      title: translations.title,
      closeLabel: translations.closeButton,
      actions: [
        Button(
          size: ButtonSize.small,
          variant: ButtonVariant.secondary,
          label: translations.continueButton,
          onPressed: () => Navigator.of(context).pop(),
        ),
        Button(
          size: ButtonSize.small,
          variant: ButtonVariant.danger,
          label: translations.exitButton,
          onPressed: () {
            Navigator.of(context).pop();
            onExit();
          },
        ),
      ],
    );
  }
}
