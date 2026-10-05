import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/settings/widgets/settings_header.dart';
import 'package:going_wild/ui/settings/widgets/settings_section.dart';

const _introStyle = TextStyle(
  fontSize: 15,
  height: 22 / 15,
  color: AppColors.ink,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w600,
);

const _updatedStyle = TextStyle(
  fontSize: 12,
  height: 16 / 12,
  color: AppColors.inkMuted,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w800,
);

const _paragraphStyle = TextStyle(
  fontSize: 14,
  height: 21 / 14,
  color: AppColors.ink,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w600,
);

class TextPageSection {
  const TextPageSection({required this.paragraphs, this.title});

  final String? title;
  final List<String> paragraphs;
}

class TextPage extends StatelessWidget {
  const TextPage({required this.title, required this.sections, super.key, this.intro, this.updated});

  final String title;
  final String? intro;
  final String? updated;
  final List<TextPageSection> sections;

  @override
  Widget build(BuildContext context) {
    final intro = this.intro;
    final updated = this.updated;
    final safeAreaPadding = MediaQuery.paddingOf(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.surface200,
        body: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.space4,
            safeAreaPadding.top + AppSpacing.space3,
            AppSpacing.space4,
            safeAreaPadding.bottom + AppSpacing.space6,
          ),
          children: [
            SettingsHeader(title: title),
            if (intro != null || updated != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(4, AppSpacing.space2, 4, AppSpacing.space4),
                child: Column(
                  spacing: AppSpacing.space1,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (intro != null) Text(intro, style: _introStyle),
                    if (updated != null) Text(updated, style: _updatedStyle),
                  ],
                ),
              ),
            for (final section in sections)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.space3),
                child: SettingsSection(
                  label: section.title,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3, horizontal: AppSpacing.space4),
                      child: Column(
                        spacing: AppSpacing.space2,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [for (final paragraph in section.paragraphs) Text(paragraph, style: _paragraphStyle)],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
