import 'package:going_wild/data/team/characters/characters.dart';
import 'package:going_wild/domain/models/models.dart';

const TeamSet davidAndGoliath = TeamSet(
  id: 'david-and-goliath',

  members: [
    bull,
    guineaPig,
  ],

  tiers: [
    SetTier(
      count: 2,
      effects: [
        SetEffect(
          value: 2,
          stat: Stat.damage,
          character: guineaPig,
          target: SetTarget.specificCharacter,
          changeType: StatChangeType.multiplier,
        ),

        SetEffect(
          value: 1.3,
          stat: Stat.armor,
          character: bull,
          target: SetTarget.specificCharacter,
          changeType: StatChangeType.multiplier,
        ),
      ],
    ),
  ],
);
