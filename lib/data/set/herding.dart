import 'package:going_wild/data/character/team/team.dart';
import 'package:going_wild/domain/models/models.dart';

const TeamSet herding = TeamSet(
  id: 'herding',

  members: [
    dog,
    sheep,
  ],

  tiers: [
    SetTier(
      count: 2,
      effects: [
        SetEffect(
          value: 1.1,
          stat: Stat.health,
          target: SetTarget.entireTeam,
          changeType: StatChangeType.multiplier,
        ),
      ],
    ),
  ],
);
