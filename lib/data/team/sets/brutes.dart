import 'package:going_wild/data/team/characters/characters.dart';
import 'package:going_wild/domain/models/models.dart';

const TeamSet brutes = TeamSet(
  id: 'brutes',

  members: [
    bull,
    horse,
    sow,
    cow,
  ],

  tiers: [
    SetTier(
      count: 2,
      effects: [
        SetEffect(
          value: 1.15,
          stat: Stat.health,
          target: SetTarget.setMembers,
          changeType: StatChangeType.multiplier,
        ),
      ],
    ),

    SetTier(
      count: 4,
      effects: [
        SetEffect(
          value: 1.35,
          stat: Stat.health,
          target: SetTarget.setMembers,
          changeType: StatChangeType.multiplier,
        ),
      ],
    ),
  ],
);
