import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stat_change_type.dart';
import 'package:going_wild/domain/models/character/stats/stat_modification.dart';
import 'package:going_wild/domain/models/set/set_effect.dart';
import 'package:going_wild/domain/models/set/set_id.dart';
import 'package:going_wild/domain/models/set/set_target.dart';
import 'package:going_wild/domain/models/set/set_tier.dart';
import 'package:going_wild/domain/models/set/team_set.dart';

const TeamSet flyers = TeamSet(
  id: SetId('flyers'),

  members: [
    chicken,
    rooster,
    duck,
    queenBee,
  ],

  tiers: [
    SetTier(
      count: 2,
      effects: [
        SetStatModification(
          target: SetTarget.setMembers,
          statModification: StatModification(stat: Stat.damage, changeType: StatChangeType.multiplier, value: 1.15),
        ),
      ],
    ),

    SetTier(
      count: 4,
      effects: [
        SetStatModification(
          target: SetTarget.setMembers,
          statModification: StatModification(stat: Stat.damage, changeType: StatChangeType.multiplier, value: 1.3),
        ),

        SetStatModification(
          target: SetTarget.setMembers,
          statModification: StatModification(stat: Stat.attackSpeed, changeType: StatChangeType.multiplier, value: 1.2),
        ),
      ],
    ),
  ],
);
