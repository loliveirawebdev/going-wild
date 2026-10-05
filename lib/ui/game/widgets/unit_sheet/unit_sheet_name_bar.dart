import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_spacing.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/design/rarity_color.dart';
import 'package:going_wild/ui/core/localization/character_name.dart';
import 'package:going_wild/ui/core/widgets/stars.dart';

const _starSize = 16.0;

const _nameStyle = TextStyle(
  fontSize: 22,
  height: 26 / 22,
  color: AppColors.onPrimary,
  fontFamily: AppFonts.display,
  fontWeight: FontWeight.w400,
);

class UnitSheetNameBar extends StatelessWidget {
  const UnitSheetNameBar({required this.characterCopy, super.key});

  final CharacterCopy characterCopy;

  @override
  Widget build(BuildContext context) {
    final character = characterCopy.character;

    return Container(
      color: rarityColorOf(character.rarity),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        spacing: AppSpacing.space2,
        children: [
          Expanded(
            child: Text(characterNameOf(context.t, character), maxLines: 1, overflow: TextOverflow.ellipsis, style: _nameStyle),
          ),
          Stars(
            size: _starSize,
            count: characterCopy.stars,
            semanticLabel: context.t.game.bench.stars(count: characterCopy.stars),
          ),
        ],
      ),
    );
  }
}
