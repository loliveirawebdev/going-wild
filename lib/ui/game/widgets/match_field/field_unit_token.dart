import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/ui/core/design/app_colors.dart';
import 'package:going_wild/ui/core/design/character_art.dart';

const _ringWidth = 3.0;

enum FieldUnitSide {
  team(ringColor: AppColors.grass600),
  enemy(ringColor: AppColors.barn600);

  final Color ringColor;
  const FieldUnitSide({required this.ringColor});
}

class FieldUnitToken extends StatelessWidget {
  final double diameter;
  final FieldUnitSide side;
  final CharacterCopy characterCopy;
  const FieldUnitToken({required this.side, required this.diameter, required this.characterCopy, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surface300,
        border: Border.all(color: side.ringColor, width: _ringWidth),
      ),
      child: ClipOval(
        child: Image.asset(
          characterHeadshotAssetPathOf(characterCopy.character),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
