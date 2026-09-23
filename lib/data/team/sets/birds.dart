import 'package:going_wild/data/team/characters/characters.dart';
import 'package:going_wild/domain/models/models.dart';

const TeamSet birds = TeamSet(
  id: 'birds',

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
        SetEffect(
          value: 1.15,
          stat: Stat.damage,
          target: SetTarget.setMembers,
          changeType: StatChangeType.multiplier,
        ),
      ],
    ),

    SetTier(
      count: 4,
      effects: [
        SetEffect(
          value: 1.3,
          stat: Stat.damage,
          target: SetTarget.setMembers,
          changeType: StatChangeType.multiplier,
        ),

        SetEffect(
          value: 1.2,
          stat: Stat.attackSpeed,
          target: SetTarget.setMembers,
          changeType: StatChangeType.multiplier,
        ),
      ],
    ),
  ],
);
