import 'package:flutter/widgets.dart';
import 'package:going_wild/domain/models/combat_history/replay/combat_replay_combatant.dart';
import 'package:going_wild/domain/models/combatant/faction.dart';
import 'package:going_wild/ui/game/unit_stage/unit/unit_head_height.dart';
import 'package:going_wild/ui/game/widgets/match_field/units/field_unit.dart';
import 'package:going_wild/ui/game/widgets/match_field/units/field_unit_status.dart';
import 'package:going_wild/ui/game/widgets/match_field/units/field_unit_token.dart';

class CombatUnit extends StatelessWidget {
  final double scale;
  final CombatReplayCombatant combatant;
  const CombatUnit({required this.scale, required this.combatant, super.key});

  @override
  Widget build(BuildContext context) {
    final sprite = combatant.characterCopy.character.sprite;

    return FieldUnit(
      vitals: combatVitalsOf(combatant),
      diameter: fieldTokenDiameterFor(scale),
      characterCopy: combatant.characterCopy,
      statusSpot: switch (combatant.faction) {
        Faction.team => const BelowFeetStatusSpot(),
        Faction.enemy => AboveHeadStatusSpot(headHeight: headHeightAboveCellCenterOf(sprite) * scale),
      },
    );
  }
}
