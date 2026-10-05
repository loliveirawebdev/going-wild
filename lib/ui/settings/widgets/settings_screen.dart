import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:going_wild/domain/models/settings/settings.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/settings/view_models/settings_view_model.dart';
import 'package:going_wild/ui/settings/widgets/about_settings_section.dart';
import 'package:going_wild/ui/settings/widgets/match_settings_section.dart';
import 'package:going_wild/ui/settings/widgets/progress_settings_section.dart';
import 'package:going_wild/ui/settings/widgets/settings_header.dart';
import 'package:going_wild/ui/settings/widgets/sound_settings_section.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final safeAreaPadding = MediaQuery.paddingOf(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.surface200,
        body: BlocBuilder<SettingsViewModel, Settings>(
          builder: (context, settings) => ListView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.space4,
              safeAreaPadding.top + AppSpacing.space3,
              AppSpacing.space4,
              safeAreaPadding.bottom + AppSpacing.space6,
            ),
            children: [
              SettingsHeader(title: context.t.settings.title),
              const SizedBox(height: AppSpacing.space3),
              SoundSettingsSection(settings: settings),
              const SizedBox(height: AppSpacing.space4),
              MatchSettingsSection(settings: settings),
              const SizedBox(height: AppSpacing.space4),
              const ProgressSettingsSection(),
              const SizedBox(height: AppSpacing.space4),
              const AboutSettingsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
