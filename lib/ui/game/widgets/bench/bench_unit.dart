import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/generated/i18n/translations.g.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/app_radius.dart';
import 'package:going_wild/ui/core/design/app_text_styles.dart';
import 'package:going_wild/ui/core/design/character_art.dart';
import 'package:going_wild/ui/core/localization/character_name.dart';
import 'package:going_wild/ui/core/widgets/stars.dart';

const _starSize = 10.0;

const _nameStyle = TextStyle(
  fontSize: 8.5,
  height: 11 / 8.5,
  color: AppColors.ink,
  fontFamily: AppFonts.sans,
  fontWeight: FontWeight.w900,
);

class BenchUnit extends StatelessWidget {
  final double nameOpacity;
  final CharacterCopy characterCopy;
  const BenchUnit({required this.nameOpacity, required this.characterCopy, super.key});

  @override
  Widget build(BuildContext context) {
    final character = characterCopy.character;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(characterHeadshotAssetPathOf(character), fit: BoxFit.cover),
        if (nameOpacity > 0)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: nameOpacity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    end: Alignment.bottomCenter,
                    begin: Alignment.topCenter,
                    colors: [AppColors.surface100.withValues(alpha: 0.92), AppColors.surface100.withValues(alpha: 0.72)],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(3, 1, 3, 2),
                  child: Text(
                    characterNameOf(context.t, character),
                    maxLines: 1,
                    style: _nameStyle,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        Positioned(
          left: 2,
          bottom: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 3),
            decoration: BoxDecoration(color: AppColors.surface100.withValues(alpha: 0.85), borderRadius: AppRadius.pill),
            child: Stars(
              size: _starSize,
              count: characterCopy.stars,
              semanticLabel: context.t.game.bench.stars(count: characterCopy.stars),
            ),
          ),
        ),
      ],
    );
  }
}
