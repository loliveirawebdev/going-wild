import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/character/character_copy.dart';
import 'package:going_wild/ui/game/widgets/match_field/units/field_unit_status.dart';

const _statusGap = 2.0;
const _touchArea = ColoredBox(color: Color(0x00000000));

sealed class FieldUnitStatusSpot {
  const FieldUnitStatusSpot();
}

class BelowFeetStatusSpot extends FieldUnitStatusSpot {
  const BelowFeetStatusSpot();
}

class AboveHeadStatusSpot extends FieldUnitStatusSpot {
  const AboveHeadStatusSpot({required this.headHeight});
  final double headHeight;
}

class FieldUnit extends StatelessWidget {
  final double diameter;
  final FieldUnitVitals vitals;
  final CharacterCopy characterCopy;
  final FieldUnitStatusSpot statusSpot;
  const FieldUnit({
    required this.vitals,
    required this.diameter,
    required this.statusSpot,
    required this.characterCopy,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final status = FieldUnitStatus(width: diameter, vitals: vitals, stars: characterCopy.stars);

    return SizedBox.square(
      dimension: diameter,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned.fill(child: _touchArea),
          switch (statusSpot) {
            BelowFeetStatusSpot() => Positioned(left: 0, width: diameter, top: diameter + _statusGap, child: status),
            AboveHeadStatusSpot(:final headHeight) => Positioned(
              left: 0,
              width: diameter,
              bottom: diameter / 2 + headHeight + _statusGap,
              child: status,
            ),
          },
        ],
      ),
    );
  }
}
