import 'package:going_wild/content/set/brutes.dart';
import 'package:going_wild/content/set/david_and_goliath.dart';
import 'package:going_wild/content/set/day_and_night.dart';
import 'package:going_wild/content/set/flyers.dart';
import 'package:going_wild/content/set/guardians.dart';
import 'package:going_wild/content/set/herding.dart';
import 'package:going_wild/content/set/pets.dart';
import 'package:going_wild/content/set/producers.dart';
import 'package:going_wild/content/set/trackers.dart';
import 'package:going_wild/domain/models/set/team_set.dart';

export 'brutes.dart';
export 'david_and_goliath.dart';
export 'day_and_night.dart';
export 'flyers.dart';
export 'guardians.dart';
export 'herding.dart';
export 'pets.dart';
export 'producers.dart';
export 'trackers.dart';

const List<TeamSet> allSets = [
  brutes,
  davidAndGoliath,
  dayAndNight,
  flyers,
  guardians,
  herding,
  pets,
  producers,
  trackers,
];
