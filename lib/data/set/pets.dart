import 'package:going_wild/data/character/team/team.dart';
import 'package:going_wild/domain/models/models.dart';

const TeamSet pets = TeamSet(
  id: 'pets',

  members: [
    dog,
    cat,
    rabbit,
    guineaPig,
  ],

  tiers: [
    SetTier(
      count: 2,
      effects: [
        SetEffect(
          value: 1.1,
          stat: Stat.attackSpeed,
          target: SetTarget.entireTeam,
          changeType: StatChangeType.multiplier,
        ),
      ],
    ),

    SetTier(
      count: 4,
      effects: [
        SetEffect(
          value: 1.2,
          stat: Stat.attackSpeed,
          target: SetTarget.entireTeam,
          changeType: StatChangeType.multiplier,
        ),

        SetEffect(
          value: 1.1,
          stat: Stat.damage,
          target: SetTarget.entireTeam,
          changeType: StatChangeType.multiplier,
        ),
      ],
    ),
  ],
);
