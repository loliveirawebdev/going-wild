import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/ui/game/widgets/match_field/units/field_unit_status.dart';
import 'package:going_wild/ui/game/widgets/match_field/units/field_unit_token.dart';

const _statusGap = 2.0;

class FieldUnit extends StatelessWidget {
  final double diameter;
  final FieldUnitSide side;
  final FieldUnitVitals vitals;
  final CharacterCopy characterCopy;
  const FieldUnit({required this.side, required this.vitals, required this.diameter, required this.characterCopy, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: diameter,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          FieldUnitToken(side: side, diameter: diameter, characterCopy: characterCopy),
          Positioned(
            left: 0,
            width: diameter,
            top: diameter + _statusGap,
            child: FieldUnitStatus(width: diameter, vitals: vitals, stars: characterCopy.stars),
          ),
        ],
      ),
    );
  }
}
