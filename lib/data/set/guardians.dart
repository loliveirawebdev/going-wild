import 'package:going_wild/data/character/team/team.dart';
import 'package:going_wild/domain/models/models.dart';

const TeamSet guardians = TeamSet(
  id: 'guardians',

  members: [
    dog,
    rooster,
    cat,
    goat,
    bull,
  ],

  tiers: [
    SetTier(
      count: 2,
      effects: [
        SetEffect(
          value: 0.85,
          target: SetTarget.teamMelees,
          stat: Stat.damageTakenPercentage,
          changeType: StatChangeType.multiplier,
        ),
      ],
    ),

    SetTier(
      count: 4,
      effects: [
        SetEffect(
          value: 0.7,
          target: SetTarget.teamMelees,
          stat: Stat.damageTakenPercentage,
          changeType: StatChangeType.multiplier,
        ),
      ],
    ),
  ],
);
