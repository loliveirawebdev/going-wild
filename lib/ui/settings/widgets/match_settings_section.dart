import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/settings/settings.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/widgets/speed_selector.dart';
import 'package:going_wild/ui/settings/view_models/settings_view_model.dart';
import 'package:going_wild/ui/settings/widgets/settings_rows.dart';
import 'package:going_wild/ui/settings/widgets/settings_section.dart';

class MatchSettingsSection extends StatelessWidget {
  const MatchSettingsSection({required this.settings, super.key});

  final Settings settings;

  @override
  Widget build(BuildContext context) {
    final translations = context.t.settings;

    return SettingsSection(
      label: translations.matchSection,
      children: [
        SettingsLabelRow(
          label: translations.combatSpeed,
          hint: translations.combatSpeedHint,
          trailing: SpeedSelector(
            multiplier: settings.combatSpeedMultiplier,
            onChanged: (multiplier) => context.read<SettingsViewModel>().changeCombatSpeed(multiplier: multiplier),
          ),
        ),
      ],
    );
  }
}
