import 'package:going_wild/data/team/characters/characters.dart';
import 'package:going_wild/domain/models/models.dart';

const TeamSet dayAndNight = TeamSet(
  id: 'day-and-night',

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
