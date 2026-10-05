import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';

const _titleStyle = TextStyle(
  fontSize: 12,
  height: 16 / 12,
  letterSpacing: 0.6,
  color: AppColors.inkMuted,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w800,
);

class SetDialogSectionTitle extends StatelessWidget {
  const SetDialogSectionTitle({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.space2),
      child: Semantics(header: true, child: Text(title.toUpperCase(), style: _titleStyle)),
    );
  }
}
