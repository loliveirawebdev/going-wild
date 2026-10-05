import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/settings/settings.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/widgets/slider.dart';
import 'package:going_wild/ui/core/widgets/switch.dart';
import 'package:going_wild/ui/settings/view_models/settings_view_model.dart';
import 'package:going_wild/ui/settings/widgets/settings_rows.dart';
import 'package:going_wild/ui/settings/widgets/settings_section.dart';

class SoundSettingsSection extends StatelessWidget {
  const SoundSettingsSection({required this.settings, super.key});

  final Settings settings;

  @override
  Widget build(BuildContext context) {
    final translations = context.t.settings;
    final settingsViewModel = context.read<SettingsViewModel>();
    String percentageOrMuted(int percentage) => percentage == 0 ? translations.muted : '$percentage%';

    return SettingsSection(
      label: translations.soundSection,
      children: [
        SettingsRow(
          child: Slider(
            label: translations.music,
            valueLabelOf: percentageOrMuted,
            value: settings.musicVolumePercentage,
            onChanged: (percentage) => settingsViewModel.changeMusicVolume(percentage: percentage),
          ),
        ),
        SettingsRow(
          child: Slider(
            valueLabelOf: percentageOrMuted,
            label: translations.soundEffects,
            value: settings.soundEffectsVolumePercentage,
            onChanged: (percentage) => settingsViewModel.changeSoundEffectsVolume(percentage: percentage),
          ),
        ),
        SettingsLabelRow(
          label: translations.vibration,
          trailing: Switch(
            showsLabel: false,
            label: translations.vibration,
            isOn: settings.isVibrationEnabled,
            onChanged: (isEnabled) => settingsViewModel.changeVibration(isEnabled: isEnabled),
          ),
        ),
      ],
    );
  }
}
