import 'package:flutter/widgets.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';

class ColorToken {
  const ColorToken({required this.name, required this.color});

  final String name;
  final Color color;
}

class ColorTokenGroup {
  const ColorTokenGroup({required this.name, required this.tokens});

  final String name;
  final List<ColorToken> tokens;
}

const colorTokenGroups = [
  ColorTokenGroup(
    name: 'Chão',
    tokens: [
      ColorToken(name: 'surface100', color: AppColors.surface100),
      ColorToken(name: 'surface200', color: AppColors.surface200),
      ColorToken(name: 'surface300', color: AppColors.surface300),
      ColorToken(name: 'surface400', color: AppColors.surface400),
    ],
  ),
  ColorTokenGroup(
    name: 'Tinta',
    tokens: [
      ColorToken(name: 'ink', color: AppColors.ink),
      ColorToken(name: 'inkMuted', color: AppColors.inkMuted),
      ColorToken(name: 'onPrimary', color: AppColors.onPrimary),
    ],
  ),
  ColorTokenGroup(
    name: 'Contorno e foco',
    tokens: [
      ColorToken(name: 'outline', color: AppColors.outline),
      ColorToken(name: 'focus', color: AppColors.focus),
    ],
  ),
  ColorTokenGroup(
    name: 'Madeira',
    tokens: [
      ColorToken(name: 'wood500', color: AppColors.wood500),
      ColorToken(name: 'wood700', color: AppColors.wood700),
    ],
  ),
  ColorTokenGroup(
    name: 'Ação',
    tokens: [
      ColorToken(name: 'grass400', color: AppColors.grass400),
      ColorToken(name: 'grass600', color: AppColors.grass600),
    ],
  ),
  ColorTokenGroup(
    name: 'Perigo',
    tokens: [
      ColorToken(name: 'barn400', color: AppColors.barn400),
      ColorToken(name: 'barn600', color: AppColors.barn600),
      ColorToken(name: 'barn800', color: AppColors.barn800),
      ColorToken(name: 'danger', color: AppColors.danger),
    ],
  ),
  ColorTokenGroup(
    name: 'Desabilitado',
    tokens: [
      ColorToken(name: 'disabled', color: AppColors.disabled),
      ColorToken(name: 'disabledShadow', color: AppColors.disabledShadow),
      ColorToken(name: 'onDisabled', color: AppColors.onDisabled),
    ],
  ),
  ColorTokenGroup(
    name: 'Recompensa e informação',
    tokens: [
      ColorToken(name: 'sun400', color: AppColors.sun400),
      ColorToken(name: 'sun600', color: AppColors.sun600),
      ColorToken(name: 'sky300', color: AppColors.sky300),
    ],
  ),
  ColorTokenGroup(
    name: 'Raridade',
    tokens: [
      ColorToken(name: 'rarityCommon', color: AppColors.rarityCommon),
      ColorToken(name: 'rarityUncommon', color: AppColors.rarityUncommon),
      ColorToken(name: 'rarityRare', color: AppColors.rarityRare),
      ColorToken(name: 'rarityEpic', color: AppColors.rarityEpic),
    ],
  ),
  ColorTokenGroup(
    name: 'Vida e combate',
    tokens: [
      ColorToken(name: 'healthHigh', color: AppColors.healthHigh),
      ColorToken(name: 'healthMedium', color: AppColors.healthMedium),
      ColorToken(name: 'healthLow', color: AppColors.healthLow),
      ColorToken(name: 'mana', color: AppColors.mana),
      ColorToken(name: 'shieldBar', color: AppColors.shieldBar),
    ],
  ),
  ColorTokenGroup(
    name: 'Campo',
    tokens: [
      ColorToken(name: 'fieldTeam', color: AppColors.fieldTeam),
      ColorToken(name: 'fieldTeamAlternate', color: AppColors.fieldTeamAlternate),
      ColorToken(name: 'fieldEnemy', color: AppColors.fieldEnemy),
      ColorToken(name: 'fieldEnemyAlternate', color: AppColors.fieldEnemyAlternate),
      ColorToken(name: 'fieldSelected', color: AppColors.fieldSelected),
      ColorToken(name: 'sideTeam', color: AppColors.sideTeam),
      ColorToken(name: 'sideEnemy', color: AppColors.sideEnemy),
      ColorToken(name: 'sceneGrass', color: AppColors.sceneGrass),
    ],
  ),
];

class ColorTokens extends StatelessWidget {
  const ColorTokens({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.space4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [for (final group in colorTokenGroups) _ColorTokenGroupSamples(group: group)],
    );
  }
}

class _ColorTokenGroupSamples extends StatelessWidget {
  const _ColorTokenGroupSamples({required this.group});

  final ColorTokenGroup group;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.space2,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(group.name, style: AppTextStyles.heading),
        Wrap(
          spacing: AppSpacing.space3,
          runSpacing: AppSpacing.space3,
          children: [for (final token in group.tokens) _ColorSwatch(token: token)],
        ),
      ],
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({required this.token});

  final ColorToken token;

  @override
  Widget build(BuildContext context) {
    final hexadecimal = token.color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase();

    return SizedBox(
      width: 100,
      child: Column(
        spacing: AppSpacing.space1,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: token.color,
              borderRadius: AppRadius.small,
              border: Border.all(color: AppColors.outline, width: AppBorderWidth.thin),
            ),
          ),
          Text(token.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.label),
          Text('#$hexadecimal', style: AppTextStyles.label.copyWith(color: AppColors.inkMuted)),
        ],
      ),
    );
  }
}
