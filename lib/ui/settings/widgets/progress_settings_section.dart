import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/widgets/button.dart';
import 'package:going_wild/ui/core/widgets/dialog.dart';
import 'package:going_wild/ui/settings/view_models/settings_view_model.dart';
import 'package:going_wild/ui/settings/widgets/settings_rows.dart';
import 'package:going_wild/ui/settings/widgets/settings_section.dart';

class ProgressSettingsSection extends StatelessWidget {
  const ProgressSettingsSection({super.key});

  Future<void> _confirmReset(BuildContext context) {
    final translations = context.t.settings;
    final settingsViewModel = context.read<SettingsViewModel>();

    return presentDialog<void>(
      context,
      dialog: Dialog(
        closeLabel: translations.closeButton,
        title: translations.resetDialogTitle,
        body: translations.resetDialogBody,
        actions: [
          Builder(
            builder: (context) => Button(
              size: ButtonSize.small,
              variant: ButtonVariant.secondary,
              label: translations.cancelButton,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Builder(
            builder: (context) => Button(
              size: ButtonSize.small,
              variant: ButtonVariant.danger,
              label: translations.resetButton,
              onPressed: () {
                Navigator.of(context).pop();
                settingsViewModel.reset();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final translations = context.t.settings;

    return SettingsSection(
      label: translations.progressSection,
      children: [
        SettingsLabelRow(
          label: translations.resetProgress,
          hint: translations.resetProgressHint,
          trailing: Button(
            size: ButtonSize.small,
            variant: ButtonVariant.danger,
            label: translations.resetButton,
            onPressed: () => _confirmReset(context),
          ),
        ),
      ],
    );
  }
}
