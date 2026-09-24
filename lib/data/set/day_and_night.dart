import 'package:going_wild/data/character/team/team.dart';
import 'package:going_wild/domain/models/models.dart';

const TeamSet dayAndNight = TeamSet(
  id: 'day_and_night',

  members: [
    rooster,
    cat,
  ],

  tiers: [
    SetTier(
      count: 2,
      effects: [
        SetEffect(
          value: 1.25,
          stat: Stat.damage,
          target: SetTarget.setMembers,
          changeType: StatChangeType.multiplier,
        ),
      ],
    ),
  ],
);
