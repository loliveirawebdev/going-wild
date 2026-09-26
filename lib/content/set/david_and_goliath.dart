import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/domain/models/character/stats/stat.dart';
import 'package:going_wild/domain/models/character/stats/stat_change_type.dart';
import 'package:going_wild/domain/models/character/stats/stat_modification.dart';
import 'package:going_wild/domain/models/set/set_effect.dart';
import 'package:going_wild/domain/models/set/set_id.dart';
import 'package:going_wild/domain/models/set/set_target.dart';
import 'package:going_wild/domain/models/set/set_tier.dart';
import 'package:going_wild/domain/models/set/team_set.dart';

const TeamSet davidAndGoliath = TeamSet(
  id: SetId('davidAndGoliath'),

  members: [
    bull,
    guineaPig,
  ],

  tiers: [
    SetTier(
      count: 2,
      effects: [
        SetStatModification(
          target: SetTarget.specificCharacter,
          character: guineaPig,
          statModification: StatModification(stat: Stat.damage, changeType: StatChangeType.multiplier, value: 2),
        ),

        SetStatModification(
          target: SetTarget.specificCharacter,
          character: bull,
          statModification: StatModification(stat: Stat.armor, changeType: StatChangeType.multiplier, value: 1.3),
        ),
      ],
    ),
  ],
);
