import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stat_change_type.dart';
import 'package:going_wild/domain/models/character/stats/stat_modification.dart';
import 'package:going_wild/domain/models/set/set_effect.dart';
import 'package:going_wild/domain/models/set/set_id.dart';
import 'package:going_wild/domain/models/set/set_target.dart';
import 'package:going_wild/domain/models/set/set_tier.dart';
import 'package:going_wild/domain/models/set/team_set.dart';

const TeamSet guardians = TeamSet(
  id: SetId('guardians'),

  members: [
    dog,
    rooster,
    cat,
    goat,
    bull,
  ],

  tiers: [
    SetTier(
      count: 2,
      effects: [
        SetStatModification(
          target: SetTarget.teamMelees,
          statModification: StatModification(stat: Stat.damageTakenPercentage, changeType: StatChangeType.multiplier, value: 0.85),
        ),
      ],
    ),

    SetTier(
      count: 4,
      effects: [
        SetStatModification(
          target: SetTarget.teamMelees,
          statModification: StatModification(stat: Stat.damageTakenPercentage, changeType: StatChangeType.multiplier, value: 0.7),
        ),
      ],
    ),
  ],
);
