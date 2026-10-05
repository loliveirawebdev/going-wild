import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';

class TextStyleToken {
  final String name;
  final TextStyle style;
  const TextStyleToken({required this.name, required this.style});
}

const textStyleTokens = [
  TextStyleToken(name: 'displayExtraLarge', style: AppTextStyles.displayExtraLarge),
  TextStyleToken(name: 'title', style: AppTextStyles.title),
  TextStyleToken(name: 'number', style: AppTextStyles.number),
  TextStyleToken(name: 'heading', style: AppTextStyles.heading),
  TextStyleToken(name: 'body', style: AppTextStyles.body),
  TextStyleToken(name: 'bodyStrong', style: AppTextStyles.bodyStrong),
  TextStyleToken(name: 'label', style: AppTextStyles.label),
];

class TextStyleTokens extends StatelessWidget {
  const TextStyleTokens({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.space3,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [for (final token in textStyleTokens) _TextStyleSample(token: token)],
    );
  }
}

class _TextStyleSample extends StatelessWidget {
  const _TextStyleSample({required this.token});

  final TextStyleToken token;

  @override
  Widget build(BuildContext context) {
    final style = token.style;
    final fontSize = style.fontSize!.round();
    final lineHeight = (style.fontSize! * style.height!).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${token.name} · $fontSize/$lineHeight · ${style.fontFamily} ${style.fontWeight!.value}',
          style: AppTextStyles.label.copyWith(color: AppColors.inkMuted),
        ),
        Text('Comprar 12', style: style),
      ],
    );
  }
}
