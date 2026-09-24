import 'package:going_wild/data/character/team/team.dart';
import 'package:going_wild/domain/models/models.dart';

const TeamSet dairy = TeamSet(
  id: 'dairy',

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
        SetEffect(
          value: 150,
          stat: Stat.shield,
          target: SetTarget.entireTeam,
          changeType: StatChangeType.absoluteValue,
        ),
      ],
    ),

    SetTier(
      count: 4,
      effects: [
        SetEffect(
          value: 400,
          stat: Stat.shield,
          target: SetTarget.entireTeam,
          changeType: StatChangeType.absoluteValue,
        ),
      ],
    ),
  ],
);
