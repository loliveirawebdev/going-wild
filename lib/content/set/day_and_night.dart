import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stat_change_type.dart';
import 'package:going_wild/domain/models/character/stats/stat_modification.dart';
import 'package:going_wild/domain/models/set/effects/set_stat_modification.dart';
import 'package:going_wild/domain/models/set/set_id.dart';
import 'package:going_wild/domain/models/set/set_tier.dart';
import 'package:going_wild/domain/models/set/targets/set_members_set_target.dart';
import 'package:going_wild/domain/models/set/team_set.dart';

const TeamSet dayAndNight = TeamSet(
  id: SetId('dayAndNight'),

  members: [
    rooster,
    cat,
  ],

  tiers: [
    SetTier(
      count: 2,
      effects: [
        SetStatModification(
          target: SetMembersSetTarget(),
          statModification: StatModification(stat: Stat.damage, changeType: StatChangeType.multiplier, value: 1.25),
        ),
      ],
    ),
  ],
);
