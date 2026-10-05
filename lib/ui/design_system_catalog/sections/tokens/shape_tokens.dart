import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_shadows.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';

class RadiusToken {
  final String name;
  final BorderRadius borderRadius;
  const RadiusToken({required this.name, required this.borderRadius});
}

class BorderWidthToken {
  final String name;
  final double width;
  const BorderWidthToken({required this.name, required this.width});
}

class ShadowToken {
  final String name;
  final Color color;
  final List<BoxShadow> shadows;
  const ShadowToken({required this.name, required this.color, required this.shadows});
}

const radiusTokens = [
  RadiusToken(name: 'small', borderRadius: AppRadius.small),
  RadiusToken(name: 'medium', borderRadius: AppRadius.medium),
  RadiusToken(name: 'large', borderRadius: AppRadius.large),
  RadiusToken(name: 'pill', borderRadius: AppRadius.pill),
];

const borderWidthTokens = [
  BorderWidthToken(name: 'thin', width: AppBorderWidth.thin),
  BorderWidthToken(name: 'thick', width: AppBorderWidth.thick),
];

const shadowTokens = [
  ShadowToken(name: 'pressNeutral', color: AppColors.surface100, shadows: AppShadows.pressNeutral),
  ShadowToken(name: 'pressGrass', color: AppColors.grass400, shadows: AppShadows.pressGrass),
  ShadowToken(name: 'pressBarn', color: AppColors.barn600, shadows: AppShadows.pressBarn),
  ShadowToken(name: 'pressSun', color: AppColors.sun400, shadows: AppShadows.pressSun),
  ShadowToken(name: 'float', color: AppColors.surface100, shadows: AppShadows.float),
];

class ShapeTokens extends StatelessWidget {
  const ShapeTokens({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.space6,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ShapeRow(children: [for (final token in radiusTokens) _RadiusSample(token: token)]),
        _ShapeRow(children: [for (final token in borderWidthTokens) _BorderWidthSample(token: token)]),
        _ShapeRow(children: [for (final token in shadowTokens) _ShadowSample(token: token)]),
      ],
    );
  }
}

class _ShapeRow extends StatelessWidget {
  const _ShapeRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.space3,
      runSpacing: AppSpacing.space6,
      children: children,
    );
  }
}

class _RadiusSample extends StatelessWidget {
  const _RadiusSample({required this.token});

  final RadiusToken token;

  @override
  Widget build(BuildContext context) {
    return _LabeledBox(
      name: token.name,
      decoration: BoxDecoration(
        color: AppColors.surface200,
        borderRadius: token.borderRadius,
        border: Border.all(color: AppColors.outline, width: AppBorderWidth.thick),
      ),
    );
  }
}

class _BorderWidthSample extends StatelessWidget {
  const _BorderWidthSample({required this.token});

  final BorderWidthToken token;

  @override
  Widget build(BuildContext context) {
    return _LabeledBox(
      name: token.name,
      decoration: BoxDecoration(
        color: AppColors.surface200,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.outline, width: token.width),
      ),
    );
  }
}

class _ShadowSample extends StatelessWidget {
  const _ShadowSample({required this.token});

  final ShadowToken token;

  @override
  Widget build(BuildContext context) {
    return _LabeledBox(
      name: token.name,
      decoration: BoxDecoration(
        color: token.color,
        boxShadow: token.shadows,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.outline, width: AppBorderWidth.thick),
      ),
    );
  }
}

class _LabeledBox extends StatelessWidget {
  const _LabeledBox({required this.name, required this.decoration});

  final String name;
  final BoxDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.space2,
      children: [
        Container(width: 88, height: 56, decoration: decoration),
        Text(name, style: AppTextStyles.label),
      ],
    );
  }
}
