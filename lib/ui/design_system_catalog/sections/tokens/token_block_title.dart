import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';

class TokenBlockTitle extends StatelessWidget {
  final String title;
  const TokenBlockTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.space6, bottom: AppSpacing.space3),
      child: Text(title, style: AppTextStyles.title),
    );
  }
}
