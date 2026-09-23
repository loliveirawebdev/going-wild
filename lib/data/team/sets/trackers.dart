import 'package:going_wild/data/team/characters/characters.dart';
import 'package:going_wild/domain/models/models.dart';

const TeamSet trackers = TeamSet(
  id: 'trackers',

  members: [
    sow,
    rabbit,
  ],

  tiers: [
    SetTier(
      count: 2,
      effects: [
        SetEffect(
          value: 0.8,
          stat: Stat.armor,
          target: SetTarget.allEnemies,
          changeType: StatChangeType.multiplier,
        ),
      ],
    ),
  ],
);
