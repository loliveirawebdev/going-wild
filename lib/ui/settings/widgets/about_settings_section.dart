import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/routing/routes.dart';
import 'package:going_wild/ui/settings/widgets/settings_rows.dart';
import 'package:going_wild/ui/settings/widgets/settings_section.dart';

class AboutSettingsSection extends StatelessWidget {
  const AboutSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final translations = context.t.settings;

    return SettingsSection(
      label: translations.aboutSection,
      children: [
        SettingsLinkRow(label: translations.credits, onTap: () => context.push(Routes.credits)),
        SettingsLinkRow(label: translations.privacy, onTap: () => context.push(Routes.privacy)),
        SettingsLinkRow(label: translations.terms, onTap: () => context.push(Routes.terms)),
      ],
    );
  }
}
