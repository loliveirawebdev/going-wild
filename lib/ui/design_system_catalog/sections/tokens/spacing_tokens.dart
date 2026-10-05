import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';

class SpaceToken {
  final String name;
  final double space;
  const SpaceToken({required this.name, required this.space});
}

const spaceTokens = [
  SpaceToken(name: 'space1', space: AppSpacing.space1),
  SpaceToken(name: 'space2', space: AppSpacing.space2),
  SpaceToken(name: 'space3', space: AppSpacing.space3),
  SpaceToken(name: 'space4', space: AppSpacing.space4),
  SpaceToken(name: 'space6', space: AppSpacing.space6),
  SpaceToken(name: 'space8', space: AppSpacing.space8),
];

class SpacingTokens extends StatelessWidget {
  const SpacingTokens({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.space2,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [for (final token in spaceTokens) _SpaceSample(token: token)],
    );
  }
}

class _SpaceSample extends StatelessWidget {
  const _SpaceSample({required this.token});

  final SpaceToken token;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.space3,
      children: [
        SizedBox(width: 72, child: Text(token.name, style: AppTextStyles.label)),
        Container(width: token.space, height: 24, color: AppColors.wood500),
        Text('${token.space.round()}', style: AppTextStyles.label.copyWith(color: AppColors.inkMuted)),
      ],
    );
  }
}
