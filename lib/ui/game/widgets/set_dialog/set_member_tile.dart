import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/character/character.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_border_width.dart';
import 'package:going_wild/ui/core/design/app_color_filters.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/design/character_art.dart';
import 'package:going_wild/ui/core/design/interface_glyph.dart';
import 'package:going_wild/ui/core/design/rarity_color.dart';
import 'package:going_wild/ui/core/localization/character_name.dart';
import 'package:going_wild/ui/core/widgets/interface_glyph_image.dart';

const _rarityFrameWidth = 3.0;
const _checkSize = 20.0;
const _nameHeight = 14.0;
const _checkOverhang = 7.0;
final _portraitInnerRadius = AppRadius.insideBorderOf(AppRadius.medium, borderWidth: _rarityFrameWidth);

const _nameStyle = TextStyle(
  fontSize: 11,
  height: _nameHeight / 11,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w800,
);

class SetMemberTile extends StatelessWidget {
  const SetMemberTile({
    required this.character,
    required this.isOnField,
    required this.portraitSize,
    required this.maxNameWidth,
    super.key,
  });

  final bool isOnField;
  final Character character;
  final double portraitSize;
  final double maxNameWidth;

  @override
  Widget build(BuildContext context) {
    final translations = context.t.game.setDialog;
    final name = characterNameOf(context.t, character);
    final portrait = Image.asset(characterHeadshotAssetPathOf(character), fit: BoxFit.cover);

    return Semantics(
      container: true,
      label: isOnField ? translations.memberOnField(name: name) : translations.memberMissing(name: name),
      child: ExcludeSemantics(
        child: Column(
          spacing: 3,
          children: [
            SizedBox.square(
              dimension: portraitSize,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface300,
                        borderRadius: AppRadius.medium,
                        border: Border.all(color: rarityColorOf(character.rarity), width: _rarityFrameWidth),
                      ),
                      child: ClipRRect(
                        borderRadius: _portraitInnerRadius,
                        child: isOnField ? portrait : ColorFiltered(colorFilter: AppColorFilters.inactiveIcon, child: portrait),
                      ),
                    ),
                  ),
                  if (isOnField) const Positioned(right: -_checkOverhang, bottom: -_checkOverhang, child: _OnFieldCheck()),
                ],
              ),
            ),
            SizedBox(
              height: _nameHeight,
              width: portraitSize,
              child: OverflowBox(
                maxWidth: maxNameWidth,
                child: Text(
                  name,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: _nameStyle.copyWith(color: isOnField ? AppColors.ink : AppColors.inkMuted),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnFieldCheck extends StatelessWidget {
  const _OnFieldCheck();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _checkSize,
      height: _checkSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.grass400,
        border: Border.all(color: AppColors.grass600, width: AppBorderWidth.thin),
      ),
      child: const InterfaceGlyphImage(InterfaceGlyph.check, size: 11, color: AppColors.ink),
    );
  }
}
