import 'package:going_wild/content/character/team/team.dart';
import 'package:going_wild/domain/models/set/effects/set_starting_shield.dart';
import 'package:going_wild/domain/models/set/set_id.dart';
import 'package:going_wild/domain/models/set/set_tier.dart';
import 'package:going_wild/domain/models/set/targets/entire_team_set_target.dart';
import 'package:going_wild/domain/models/set/team_set.dart';

const TeamSet producers = TeamSet(
  id: SetId('producers'),

  members: [
    cow,
    sheep,
    goat,
    queenBee,
  ],

  tiers: [
    SetTier(
      count: 2,
      effects: [
        SetStartingShield(target: EntireTeamSetTarget(), value: 150, seconds: 8),
      ],
    ),

    SetTier(
      count: 4,
      effects: [
        SetStartingShield(target: EntireTeamSetTarget(), value: 400, seconds: 8),
      ],
    ),
  ],
);
